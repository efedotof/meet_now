package com.efedotov.meet_now.meet_now.dto.request.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class ContinueChatResponseRequest {
    private UUID tempChatId;
    private UUID userId;
    private boolean accepted;
}