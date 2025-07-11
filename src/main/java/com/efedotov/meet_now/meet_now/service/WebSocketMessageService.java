package com.efedotov.meet_now.meet_now.service;

import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class WebSocketMessageService {

    private final MessageRepository messageRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public Message processMessage(Message message) {
        message.setCreatedAt(LocalDateTime.now());
        Message saved = messageRepository.save(message);

        messagingTemplate.convertAndSendToUser(
                message.getRecipient().getId().toString(),
                "/queue/messages",
                saved
        );

        return saved;
    }
}
