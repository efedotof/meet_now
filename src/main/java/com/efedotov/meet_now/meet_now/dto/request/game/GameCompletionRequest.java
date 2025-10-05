package com.efedotov.meet_now.meet_now.dto.request.game;

import java.util.UUID;

import lombok.Data;

@Data
public class GameCompletionRequest {
    private UUID userId;
    private UUID chatId;
    private String gameType;
    private int score;
}
