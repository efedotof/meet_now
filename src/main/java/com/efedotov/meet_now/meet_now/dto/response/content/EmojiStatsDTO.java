package com.efedotov.meet_now.meet_now.dto.response.content;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class EmojiStatsDTO {
    private String emoji;
    private Long usageCount;
}