package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;
import java.util.UUID;

@Data
@Builder
public class AdminUserGiftStatsDto {
    private UUID userId;
    private String username;
    private Long sentCount;
    private Long receivedCount;
    private Long inventoryCount;
    private Integer currentStreak;
    private Integer maxStreak;
    private Long dailyGiftsCount;
    private UUID mostPopularSentGiftId;
    private Long mostPopularSentGiftCount;
    private UUID mostPopularReceivedGiftId;
    private Long mostPopularReceivedGiftCount;
}