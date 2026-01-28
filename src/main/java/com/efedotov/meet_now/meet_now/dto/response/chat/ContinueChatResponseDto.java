package com.efedotov.meet_now.meet_now.dto.response.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class ContinueChatResponseDto {
    private UUID tempChatId;
    private UUID userId;
    private boolean accepted;
    private PermanentChatResponseDto permanentChat;
}