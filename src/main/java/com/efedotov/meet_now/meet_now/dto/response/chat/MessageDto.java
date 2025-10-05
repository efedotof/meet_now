package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonProperty;

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
    @JsonProperty("isRead")
    private boolean isRead;
}