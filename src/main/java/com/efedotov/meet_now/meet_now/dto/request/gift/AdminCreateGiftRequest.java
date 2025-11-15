package com.efedotov.meet_now.meet_now.dto.request.gift;

import lombok.Data;
import java.util.UUID;

@Data
public class AdminCreateGiftRequest {
    private String name;
    private String description;
    private String imageUrl;
    private String animationUrl;
    private String giftType;
    private UUID rarityId;
    private Integer costPoints;
}