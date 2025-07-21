package com.efedotov.meet_now.meet_now.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Data;

@Data
public class MessageDto {
    private UUID id;
    private UUID chatId;
    private UUID senderId;
    private UUID recipientId;
    private String text;
    private LocalDateTime createdAt;
    private UUID tempChatId;
    private boolean isRead;
}