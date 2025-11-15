package com.efedotov.meet_now.meet_now.dto.request.content;

import lombok.Data;
import java.util.UUID;

@Data
public class StickerCreateRequest {
    private UUID packId;
    private String emoji;
    private String imageUrl;
}