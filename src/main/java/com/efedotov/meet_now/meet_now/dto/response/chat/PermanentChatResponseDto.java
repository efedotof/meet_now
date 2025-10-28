package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.time.LocalDateTime;
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
    private String user2Username;
    private String user2Firstname;
    private String user2Subname;
    private String user2Avatar;
    private LocalDateTime createdAt;
    private Boolean isOpened;
    private String lastMessage;
}