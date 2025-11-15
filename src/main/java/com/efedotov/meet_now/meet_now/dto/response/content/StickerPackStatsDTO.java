package com.efedotov.meet_now.meet_now.dto.response.content;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StickerPackStatsDTO {
    private String packTitle;
    private Long stickerCount;
}