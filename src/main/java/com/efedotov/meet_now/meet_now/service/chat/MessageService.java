package com.efedotov.meet_now.meet_now.service.chat;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.chat.Message;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;

    public List<Message> getMessagesByChatId(UUID chatId) {
        return messageRepository.findByChat_ChatIdOrderByCreatedAtAsc(chatId);
    }
}
