package com.efedotov.meet_now.meet_now.dto.request.chat;

import lombok.Data;

import java.util.UUID;

@Data
public class PaginatedMessagesRequest {
    private UUID chatId;
    private int page;
    private int size;
}