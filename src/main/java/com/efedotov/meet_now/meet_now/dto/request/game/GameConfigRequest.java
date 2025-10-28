package com.efedotov.meet_now.meet_now.dto.request.game;

import java.math.BigDecimal;

import lombok.Data;

@Data
public class GameConfigRequest {
    private String gameType;
    private String gameUrl;
    private BigDecimal scoreMultiplier;
    private String gameName;
    private String gameDescription;
    private String thumbnailUrl;
    private Boolean isActive;
}