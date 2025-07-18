package com.efedotov.meet_now.meet_now.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.MessageDto;
import com.efedotov.meet_now.meet_now.model.Chat;
import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.model.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.repository.UserRepository;

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
        UUID senderId = messageDto.getSenderId();
        UUID recipientId = messageDto.getRecipientId();
        String text = messageDto.getText();
        log.info("Пользователь отправил сообщение: от {} к {}, текст: {}", senderId, recipientId, text);
        User sender = userRepository.findById(senderId).orElseThrow(() -> new RuntimeException("Sender not found"));
        User recipient = userRepository.findById(recipientId)
                .orElseThrow(() -> new RuntimeException("Recipient not found"));

        Chat chat = null;
        TemporaryChat tempChat = null;

        if (chatId != null) {
            Optional<Chat> chatOpt = chatRepository.findById(chatId);
            if (chatOpt.isPresent()) {
                chat = chatOpt.get();
            } else {
                Optional<TemporaryChat> tempChatOpt = temporaryChatRepository.findById(chatId);
                if (tempChatOpt.isPresent()) {
                    tempChat = tempChatOpt.get();
                } else {
                    throw new RuntimeException("Chat not found by chatId");
                }
            }
        } else {
            Optional<Chat> chatOpt = chatRepository.findByUser1IdAndUser2Id(senderId, recipientId);
            if (chatOpt.isEmpty()) {
                chatOpt = chatRepository.findByUser1IdAndUser2Id(recipientId, senderId);
            }
            if (chatOpt.isPresent()) {
                chat = chatOpt.get();
                chat.setLastMessage(text);
                messageDto.setChatId(chat.getChatId());
            } else {
                List<TemporaryChat> tempChats = temporaryChatRepository.findBySender_IdOrRecipient_Id(senderId,
                        recipientId);
                for (TemporaryChat tchat : tempChats) {
                    if ((tchat.getSender().getId().equals(senderId) && tchat.getRecipient().getId().equals(recipientId))
                            ||
                            (tchat.getSender().getId().equals(recipientId)
                                    && tchat.getRecipient().getId().equals(senderId))) {
                        tempChat = tchat;
                        messageDto.setChatId(tchat.getTempChatId());
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
                    messageDto.setChatId(tempChat.getTempChatId());
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
            messageRepository.save(message);

            chat.setLastMessage(text);
            chatRepository.save(chat);

        } else if (tempChat != null) {
            message.setTemporaryChat(tempChat);
            messageRepository.save(message);
        }

        messagingTemplate.convertAndSendToUser(
                recipient.getId().toString(),
                "/queue/messages",
                messageDto);

        return messageDto;
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

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.messages",
                messages);
    }

    public List<TemporaryChat> getActiveTemporaryChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных временных чатов", userId);
        return chatService.getActiveTemporaryChatsForUser(userId);
    }

    public List<Chat> getPermanentChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных постоянных чатов", userId);
        return chatService.getPermanentChatsForUser(userId);
    }

}
