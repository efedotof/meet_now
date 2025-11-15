package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Data;

@Data
public class SystemMetrics {
    private long totalIcebreakerTopics;
    private long totalStickerPacks;
    private long totalStickers;
    private long totalCities;
    private long totalInterests;
    private long totalPurposes;
    private long activeSessions;
    private double systemUptimeHours;
}
