package com.efedotov.meet_now.meet_now.dto.response.game;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GameTypeStatsDTO {
    private String gameType;
    private Long gameCount;
}