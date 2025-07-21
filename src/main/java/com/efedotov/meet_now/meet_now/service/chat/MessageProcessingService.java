package com.efedotov.meet_now.meet_now.service.chat;

import com.efedotov.meet_now.meet_now.dto.MessageDto;
import com.efedotov.meet_now.meet_now.model.*;
import com.efedotov.meet_now.meet_now.repository.*;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageProcessingService {

    private final MessageRepository messageRepository;
    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public MessageDto processMessageDto(MessageDto messageDto) {
        UUID chatId = messageDto.getChatId();
        UUID tempChatId = messageDto.getTempChatId();
        UUID senderId = messageDto.getSenderId();
        UUID recipientId = messageDto.getRecipientId();
        String text = messageDto.getText();

        log.info("Пользователь отправил сообщение: от {} к {}, текст: {}", senderId, recipientId, text);

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("Sender not found"));
        User recipient = userRepository.findById(recipientId)
                .orElseThrow(() -> new RuntimeException("Recipient not found"));

        Chat chat = null;
        TemporaryChat tempChat = null;
        UUID finalChatId;
        boolean isTemporary = false;

        if (chatId != null || tempChatId != null) {
            if (chatId != null) {
                chat = chatRepository.findById(chatId)
                        .orElseThrow(() -> new RuntimeException("Chat not found"));
                finalChatId = chatId;
            } else {
                tempChat = temporaryChatRepository.findById(tempChatId)
                        .orElseThrow(() -> new RuntimeException("Temporary chat not found"));
                finalChatId = tempChatId;
                isTemporary = true;
            }
        } else {
            chat = findOrCreateChat(sender, recipient, text);
            if (chat != null) {
                finalChatId = chat.getChatId();
            } else {
                tempChat = findOrCreateTemporaryChat(sender, recipient);
                finalChatId = tempChat.getTempChatId();
                isTemporary = true;
            }
        }

        Message message = createMessage(sender, recipient, text, chat, tempChat);
        message = messageRepository.save(message);

        MessageDto responseDto = createResponseDto(message, finalChatId, isTemporary);
        messagingTemplate.convertAndSendToUser(
                recipient.getUsername(),
                "/queue/messages",
                responseDto);

        log.info("Отправляем сообщение пользователю как оповещение {} от {} сообщение {}",
                recipient.getUsername(), sender.getUsername(), responseDto.getText());

        return responseDto;
    }

    private Chat findOrCreateChat(User sender, User recipient, String text) {
        UUID senderId = sender.getId();
        UUID recipientId = recipient.getId();

        Optional<Chat> existingChat = chatRepository.findByUser1IdAndUser2Id(senderId, recipientId)
                .or(() -> chatRepository.findByUser1IdAndUser2Id(recipientId, senderId));

        if (existingChat.isPresent()) {
            Chat chat = existingChat.get();
            chat.setLastMessage(text);
            chatRepository.save(chat);
            return chat;
        }
        return null;
    }

    private TemporaryChat findOrCreateTemporaryChat(User sender, User recipient) {
        UUID senderId = sender.getId();
        UUID recipientId = recipient.getId();
        List<TemporaryChat> tempChats = temporaryChatRepository.findBySender_IdOrRecipient_Id(senderId, recipientId);

        for (TemporaryChat tchat : tempChats) {
            if ((tchat.getSender().getId().equals(senderId) && tchat.getRecipient().getId().equals(recipientId)) ||
                    (tchat.getSender().getId().equals(recipientId) && tchat.getRecipient().getId().equals(senderId))) {
                return tchat;
            }
        }

        TemporaryChat tempChat = new TemporaryChat();
        tempChat.setSender(sender);
        tempChat.setRecipient(recipient);
        tempChat.setCreatedAt(LocalDateTime.now());
        tempChat.setDurationMinutes(5);
        tempChat.setIsFinished(false);
        tempChat.setBothAgreed(false);
        return temporaryChatRepository.save(tempChat);
    }

    private Message createMessage(User sender, User recipient, String text, Chat chat, TemporaryChat tempChat) {
        Message message = new Message();
        message.setSender(sender);
        message.setRecipient(recipient);
        message.setText(text);
        message.setCreatedAt(LocalDateTime.now());
        message.setRead(false);
        if (chat != null) {
            message.setChat(chat);
        } else if (tempChat != null) {
            message.setTemporaryChat(tempChat);
        }

        return message;
    }

    private MessageDto createResponseDto(Message message, UUID finalChatId, boolean isTemporary) {
        MessageDto dto = new MessageDto();
        dto.setId(message.getId());
        dto.setText(message.getText());
        dto.setCreatedAt(message.getCreatedAt());
        dto.setSenderId(message.getSender().getId());
        dto.setRecipientId(message.getRecipient().getId());
        dto.setRead(message.isRead());
        if (isTemporary) {
            dto.setTempChatId(finalChatId);
        } else {
            dto.setChatId(finalChatId);
        }

        return dto;
    }

    @Transactional
    public void markMessagesAsRead(List<UUID> messageIds, UUID userId) {
        List<Message> messages = messageRepository.findAllById(messageIds);

        messages.stream()
                .filter(msg -> msg.getRecipient().getId().equals(userId))
                .forEach(msg -> {
                    if (!msg.isRead()) {
                        msg.setRead(true);
                        messageRepository.save(msg);
                    }
                });

        log.info("Marked {} messages as read for user {}", messages.size(), userId);
    }

}