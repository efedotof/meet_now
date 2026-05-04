package com.efedotov.meet_now.meet_now.service.chat;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class PermanentChatUpdateService {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatRepository chatRepository;
    private final UserRepository userRepository;
    private final MessageRepository messageRepository;

    public void sendUpdatedPermanentChats(UUID userId) {
        var user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<PermanentChatResponseDto> chatDtos = getPermanentChatsAsDto(userId);

        log.info("Отправка обновленного списка постоянных чатов пользователю {} ({} чатов)",
                user.getUsername(), chatDtos.size());

        messagingTemplate.convertAndSendToUser(
                user.getUsername(),
                "queue/chat.permanent.updated",
                chatDtos);
    }

    public void sendUpdatedPermanentChatsToUsers(List<UUID> userIds) {
        for (UUID userId : userIds) {
            sendUpdatedPermanentChats(userId);
        }
    }

    public void notifyNewMessageInPermanentChat(UUID chatId, UUID senderId, UUID recipientId) {
        log.info("Уведомление о новом сообщении в постоянном чате {} для пользователей {} и {}",
                chatId, senderId, recipientId);

        sendUpdatedPermanentChats(senderId);
        sendUpdatedPermanentChats(recipientId);
    }

    public void notifyMessagesRead(UUID chatId, UUID userId) {
        log.info("Уведомление о прочтении сообщений в чате {} пользователем {}", chatId, userId);

        var chat = chatRepository.findById(chatId).orElse(null);
        if (chat != null) {
            sendUpdatedPermanentChats(chat.getUser1().getId());
            sendUpdatedPermanentChats(chat.getUser2().getId());
        }
    }

    private List<PermanentChatResponseDto> getPermanentChatsAsDto(UUID userId) {
        List<Chat> chats = chatRepository.findByUser1IdOrUser2Id(userId, userId);
        return chats.stream()
                .map(chat -> convertToPermanentChatDto(chat, userId))
                .collect(Collectors.toList());
    }

    private PermanentChatResponseDto convertToPermanentChatDto(Chat chat, UUID userId) {
        PermanentChatResponseDto dto = new PermanentChatResponseDto();
        User user1 = chat.getUser1();
        User user2 = chat.getUser2();

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

        if (user1.getRoles() != null) {
            Set<String> roles = user1.getRoles().stream()
                    .map(Role::getRoleName)
                    .collect(Collectors.toSet());
            dto.setRolesUser1(roles);
        }
        if (user2.getRoles() != null) {
            Set<String> roles = user2.getRoles().stream()
                    .map(Role::getRoleName)
                    .collect(Collectors.toSet());
            dto.setRolesUser2(roles);
        }
        dto.setLastMessage(chat.getLastMessage());
        dto.setLastMessageAt(chat.getLastMessageAt());

        Long unreadCount = messageRepository.countUnreadMessagesInChat(chat.getChatId(), userId);
        Long totalMessages = messageRepository.countByChat_ChatId(chat.getChatId());

        dto.setUnreadCount(unreadCount);
        dto.setTotalMessages(totalMessages);
        if (userId.equals(chat.getUser1().getId())) {
            dto.setEncryptedAesKey(chat.getEncryptedAesKeyForUser1());
        } else if (userId.equals(chat.getUser2().getId())) {
            dto.setEncryptedAesKey(chat.getEncryptedAesKeyForUser2());
        }
        return dto;
    }

}