package com.efedotov.meet_now.meet_now.dto;

import java.util.UUID;

import lombok.Data;

@Data
public class MessageDto {
    private UUID chatId;
    private UUID senderId;
    private UUID recipientId;
    private String text;
}
