package com.efedotov.meet_now.meet_now.dto.response.content;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class StickerStatisticsResponse {
    private Long totalPacks;
    private Long totalStickers;
    private List<StickerPackStatsDTO> stickersPerPack;
    private List<EmojiStatsDTO> popularEmojis;
}