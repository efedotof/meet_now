package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Data;

@Data
public class ChatDto {
    private UUID chatId;
    private UUID user1Id;
    private UUID user2Id;
    private LocalDateTime createdAt;
    private Boolean isOpened;
    private String lastMessage;
}
