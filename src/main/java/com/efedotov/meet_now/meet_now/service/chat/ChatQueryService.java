package com.efedotov.meet_now.meet_now.service.chat;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

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

    public List<PermanentChatResponseDto> getPermanentChatsAsDto(UUID userId) {
        log.info("Пользователь: {} запросил список активных постоянных чатов как DTO", userId);
        List<Chat> chats = chatService.getPermanentChatsForUser(userId);
        return chats.stream()
                .map(this::convertToPermanentChatDto)
                .toList();
    }

    private PermanentChatResponseDto convertToPermanentChatDto(Chat chat) {
        PermanentChatResponseDto dto = new PermanentChatResponseDto();
        dto.setChatId(chat.getChatId());
        dto.setUser1Id(chat.getUser1().getId());
        dto.setUser1Username(chat.getUser1().getUsername());
        dto.setUser1Firstname(chat.getUser1().getFirstname());
        dto.setUser1Subname(chat.getUser1().getSubname());
        dto.setUser1Avatar(chat.getUser1().getAvatar());
        dto.setUser2Id(chat.getUser2().getId());
        dto.setUser2Username(chat.getUser2().getUsername());
        dto.setUser2Firstname(chat.getUser2().getFirstname());
        dto.setUser2Subname(chat.getUser2().getSubname());
        dto.setUser2Avatar(chat.getUser2().getAvatar());
        dto.setCreatedAt(chat.getCreatedAt());
        dto.setIsOpened(chat.getIsOpened());
        dto.setLastMessage(chat.getLastMessage());
        return dto;
    }
}