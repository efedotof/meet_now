package com.efedotov.meet_now.meet_now.dto.request;

import java.util.UUID;

import lombok.Data;

@Data
public class ChatMessagesRequest {
    private UUID chatId;
    private UUID userId;
}
