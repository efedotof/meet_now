package com.efedotov.meet_now.meet_now.dto.request.content;

import lombok.Data;

@Data
public class StickerUpdateRequest {
    private String emoji;
    private String imageUrl;
}
