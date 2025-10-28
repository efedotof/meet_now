package com.efedotov.meet_now.meet_now.dto.request.game;

import java.util.UUID;

import jakarta.annotation.Nullable;
import lombok.Data;

@Data
public class GameCompletionRequest {
    @Nullable
    private UUID chatId;  
    private String gameType;
    private int score;
}