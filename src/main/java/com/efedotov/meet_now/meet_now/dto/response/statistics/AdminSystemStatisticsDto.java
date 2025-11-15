package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AdminSystemStatisticsDto {
    private UserStatistics userStatistics;
    private ChatStatistics chatStatistics;
    private GiftStatistics giftStatistics;
    private GameStatistics gameStatistics;
    private ReportStatistics reportStatistics;
    private SystemMetrics systemMetrics;
    private LocalDateTime generatedAt;
}