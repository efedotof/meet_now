package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MatchmakingResponse {
    private boolean success;
    private String message;
    private PermanentChatResponseDto permanentChat;
    private int pointsSpent;
    private UUID chatId;
}