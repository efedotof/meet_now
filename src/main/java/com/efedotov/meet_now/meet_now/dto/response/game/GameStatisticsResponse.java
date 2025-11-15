package com.efedotov.meet_now.meet_now.dto.response.game;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class GameStatisticsResponse {
    private Long totalGames;
    private Long totalChatGames;
    private Long totalStandaloneGames;
    private List<GameTypeStatisticDto> gamesByType;
    private List<GameTypeStatsDTO> popularGames;
    private LocalDateTime generatedAt;
}