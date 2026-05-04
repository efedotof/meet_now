package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

import lombok.Data;

@Data
public class PermanentChatResponseDto {
    private UUID chatId;
    private UUID user1Id;
    private String user1Username;
    private String user1Firstname;
    private String user1Subname;
    private String user1Avatar;
    private UUID user2Id;
    private Set<String> rolesUser1;
    private Set<String> rolesUser2;
    private String user2Username;
    private String user2Firstname;
    private String user2Subname;
    private String user2Avatar;
    private LocalDateTime createdAt;
    private Boolean isOpened;
    private String lastMessage;
    private LocalDateTime lastMessageAt;
    private Long unreadCount;
    private Long totalMessages;
    private String encryptedAesKey;
}
