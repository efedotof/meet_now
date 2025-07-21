package com.efedotov.meet_now.meet_now.service.websocket;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.MessageDto;
import com.efedotov.meet_now.meet_now.dto.UserActivityDto;
import com.efedotov.meet_now.meet_now.model.Chat;
import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.model.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.UserRepository;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class WebSocketMessageService {

    private final MessageRepository messageRepository;
    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

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
        UUID finalChatId = null;
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
            Optional<Chat> existingChat = chatRepository.findByUser1IdAndUser2Id(senderId, recipientId)
                    .or(() -> chatRepository.findByUser1IdAndUser2Id(recipientId, senderId));

            if (existingChat.isPresent()) {
                chat = existingChat.get();
                chat.setLastMessage(text);
                chatRepository.save(chat);
                finalChatId = chat.getChatId();
            } else {
                List<TemporaryChat> tempChats = temporaryChatRepository.findBySender_IdOrRecipient_Id(senderId,
                        recipientId);
                for (TemporaryChat tchat : tempChats) {
                    if ((tchat.getSender().getId().equals(senderId) && tchat.getRecipient().getId().equals(recipientId))
                            ||
                            (tchat.getSender().getId().equals(recipientId)
                                    && tchat.getRecipient().getId().equals(senderId))) {
                        tempChat = tchat;
                        finalChatId = tchat.getTempChatId();
                        isTemporary = true;
                        break;
                    }
                }

                if (tempChat == null) {
                    tempChat = new TemporaryChat();
                    tempChat.setSender(sender);
                    tempChat.setRecipient(recipient);
                    tempChat.setCreatedAt(LocalDateTime.now());
                    tempChat.setDurationMinutes(5);
                    tempChat.setIsFinished(false);
                    tempChat.setBothAgreed(false);
                    tempChat = temporaryChatRepository.save(tempChat);
                    finalChatId = tempChat.getTempChatId();
                    isTemporary = true;
                }
            }
        }

        Message message = new Message();
        message.setSender(sender);
        message.setRecipient(recipient);
        message.setText(text);
        message.setCreatedAt(LocalDateTime.now());

        if (chat != null) {
            message.setChat(chat);
        } else if (tempChat != null) {
            message.setTemporaryChat(tempChat);
        }

        message = messageRepository.save(message);
        MessageDto responseDto = new MessageDto();
        responseDto.setId(message.getId());
        responseDto.setText(message.getText());
        responseDto.setCreatedAt(message.getCreatedAt());
        responseDto.setSenderId(senderId);
        responseDto.setRecipientId(recipientId);

        if (isTemporary) {
            responseDto.setTempChatId(finalChatId);
        } else {
            responseDto.setChatId(finalChatId);
        }

        messagingTemplate.convertAndSendToUser(
                recipient.getUsername(),
                "/queue/messages",
                responseDto);
        log.info("Отправляем сообщение пользователю как оповещение {} от {} сообщение {}", recipient.getUsername(),
                sender.getUsername(), responseDto.getText());
        return responseDto;
    }

    public void sendActivityNotification(UserActivityDto activityDto) {
        UUID chatId = activityDto.getChatId();
        String topic = "/topic/chat.activity." + chatId;
        messagingTemplate.convertAndSend(topic, activityDto);
    }

    public void sendMessagesForChatToUser(UUID chatId, String username) {
        List<Message> messages;
        log.info("Запрос пользователя {} на получение сообщений чата {}", username, chatId);

        if (chatRepository.existsById(chatId)) {
            messages = messageRepository.findByChat_ChatIdOrderByCreatedAtAsc(chatId);
            log.info("Пользователь {} запросил сообщения из обычного чата {}", username, chatId);
        } else if (temporaryChatRepository.existsById(chatId)) {
            messages = messageRepository.findByTemporaryChat_TempChatIdOrderByCreatedAtAsc(chatId);
            log.info("Пользователь {} запросил сообщения из временного чата {}", username, chatId);
        } else {
            log.warn("Чат с ID {} не найден для пользователя {}", chatId, username);
            return;
        }

        List<MessageDto> dtos = messages.stream()
                .map(this::convertToDto)
                .toList();

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.messages",
                dtos);
    }

    public List<TemporaryChat> getActiveTemporaryChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных временных чатов", userId);
        return chatService.getActiveTemporaryChatsForUser(userId);
    }

    public List<Chat> getPermanentChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных постоянных чатов", userId);
        return chatService.getPermanentChatsForUser(userId);
    }

    private MessageDto convertToDto(Message message) {
        MessageDto dto = new MessageDto();
        dto.setId(message.getId());
        dto.setText(message.getText());
        dto.setCreatedAt(message.getCreatedAt());
        dto.setSenderId(message.getSender().getId());
        dto.setRecipientId(message.getRecipient().getId());

        if (message.getChat() != null) {
            dto.setChatId(message.getChat().getChatId());
        }
        if (message.getTemporaryChat() != null) {
            dto.setTempChatId(message.getTemporaryChat().getTempChatId());
        }

        return dto;
    }

}
