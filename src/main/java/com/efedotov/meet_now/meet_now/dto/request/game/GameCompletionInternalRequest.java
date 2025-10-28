package com.efedotov.meet_now.meet_now.dto.request.game;

import java.util.UUID;

import jakarta.annotation.Nullable;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class GameCompletionInternalRequest {
    private UUID userId;
    @Nullable
    private UUID chatId;
    private String gameType;
    private int score;
}