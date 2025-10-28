package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GiftStatsDto {
    private Long sentCount;
    private Long receivedCount;
    private Long inventoryCount;
    private Integer currentStreak;
    private Integer maxStreak;
}