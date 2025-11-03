package com.efedotov.meet_now.meet_now.service.chat;

import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatQueryService {

    private final ChatService chatService;
    private final ChatRepository chatRepository;
    private final MessageRepository messageRepository;

    public List<TemporaryChat> getActiveTemporaryChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных временных чатов", userId);
        return chatService.getActiveTemporaryChatsForUser(userId);
    }

    public Optional<Chat> getPermanentChatById(UUID chatId) {
        return chatService.getPermanentChatById(chatId);
    }

    public List<Chat> getPermanentChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных постоянных чатов", userId);
        return chatService.getPermanentChatsForUser(userId);
    }

    public List<PermanentChatResponseDto> getPermanentChatsAsDto(UUID userId) {
        log.info("Пользователь: {} запросил список активных постоянных чатов как DTO", userId);
        List<Chat> chats = chatService.getPermanentChatsForUser(userId);
        return chats.stream()
                .map(chat -> convertToPermanentChatDto(chat, userId))
                .toList();
    }

    private PermanentChatResponseDto convertToPermanentChatDto(Chat chat, UUID userId) {
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
        dto.setLastMessageAt(chat.getLastMessageAt());

        Long unreadCount = messageRepository.countUnreadMessagesInChat(chat.getChatId(), userId);
        Long totalMessages = messageRepository.countByChat_ChatId(chat.getChatId());

        dto.setUnreadCount(unreadCount);
        dto.setTotalMessages(totalMessages);

        return dto;
    }

    public Optional<PermanentChatResponseDto> getPermanentChatByUsers(UUID user1Id, UUID user2Id) {
        Optional<Chat> chat = chatRepository.findByUser1IdAndUser2Id(user1Id, user2Id)
                .or(() -> chatRepository.findByUser1IdAndUser2Id(user2Id, user1Id));

        return chat.map(c -> convertToPermanentChatDto(c, user1Id));
    }

}