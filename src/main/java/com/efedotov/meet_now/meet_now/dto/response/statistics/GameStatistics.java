package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Data;
import java.util.List;

import com.efedotov.meet_now.meet_now.dto.response.game.GameTypeStatisticDto;

@Data
public class GameStatistics {
    private long totalGamesPlayed;
    private long activeGames;
    private List<GameTypeStatisticDto> gamesByType;
    private long totalGamePoints;
    private double avgPointsPerUser;
}