package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.util.UUID;

import lombok.Data;

@Data
public class ChatGameDto {
    private UUID id;
    private UUID chatId;
    private String gameType;
    private String state;
}
