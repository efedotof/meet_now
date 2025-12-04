package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AdminGiftStatsDto {
    private Long totalGifts;
    private Long activeGifts;
    private Long totalRarities;
    private Long activeRarities;
    private Long totalSentGifts;
    private Long totalDailyGifts;
    private Long totalInventoryItems;
    private Long sentGiftsLastWeek;
    private Long dailyGiftsLastWeek;
    private Long limitedGifts;
    private Long availableLimitedGifts;
    private Long soldOutGifts;
}