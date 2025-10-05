package com.efedotov.meet_now.meet_now.service.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;

import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatQueryService {

    private final ChatService chatService;

    public List<TemporaryChat> getActiveTemporaryChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных временных чатов", userId);
        return chatService.getActiveTemporaryChatsForUser(userId);
    }

    public List<Chat> getPermanentChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных постоянных чатов", userId);
        return chatService.getPermanentChatsForUser(userId);
    }
}