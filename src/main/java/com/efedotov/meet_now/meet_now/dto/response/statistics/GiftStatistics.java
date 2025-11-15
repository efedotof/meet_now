package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Data;
import java.util.List;

import com.efedotov.meet_now.meet_now.dto.response.gift.GiftRarityStatisticDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftTypeStatisticDto;

@Data
public class GiftStatistics {
    private long totalGifts;
    private long totalSentGifts;
    private long totalDailyGifts;
    private long giftsSentLast24h;
    private long totalInventoryItems;
    private List<GiftRarityStatisticDto> giftsByRarity;
    private List<GiftTypeStatisticDto> giftsByType;
}