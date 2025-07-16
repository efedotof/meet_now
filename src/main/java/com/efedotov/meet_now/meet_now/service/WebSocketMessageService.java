package com.efedotov.meet_now.meet_now.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.Chat;
import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.repository.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.MessageRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WebSocketMessageService {

    private final MessageRepository messageRepository;
    private final ChatRepository chatRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public Message processMessage(Message message) {
        message.setCreatedAt(LocalDateTime.now());
        Message saved = messageRepository.save(message);
        UUID chatId = message.getChat().getChatId();
        Optional<Chat> optionalChat = chatRepository.findById(chatId);

        optionalChat.ifPresent(chat -> {
            chat.setLastMessage(message.getText());
            chatRepository.save(chat);
        });

        messagingTemplate.convertAndSendToUser(
                message.getRecipient().getId().toString(),
                "/queue/messages",
                saved
        );

        return saved;
    }

    public void sendMessagesForChatToUser(UUID chatId, String userId) {
        List<Message> messages = messageRepository.findByChat_ChatIdOrderByCreatedAtAsc(chatId);
        messagingTemplate.convertAndSendToUser(
                userId,
                "/queue/chat." + chatId + ".messages",
                messages
        );
    }
}
