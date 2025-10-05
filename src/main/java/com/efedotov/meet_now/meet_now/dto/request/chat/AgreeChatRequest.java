package com.efedotov.meet_now.meet_now.dto.request.chat;

import java.util.UUID;

import lombok.Data;

@Data
public class AgreeChatRequest {
    private UUID tempChatId;
    private UUID userId;
}
