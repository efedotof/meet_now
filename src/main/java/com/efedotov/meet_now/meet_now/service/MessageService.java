package com.efedotov.meet_now.meet_now.service;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.repository.MessageRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;

    public List<Message> getMessagesByChatId(UUID chatId) {
        return messageRepository.findByChat_ChatIdOrderByCreatedAtAsc(chatId);
    }
}
