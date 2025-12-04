package com.efedotov.meet_now.meet_now.dto.request.gift;

import lombok.Data;
import java.util.UUID;

@Data
public class AdminUpdateGiftRequest {
    private String name;
    private String description;
    private String imageUrl;
    private String animationUrl;
    private String giftType;
    private UUID rarityId;
    private Integer costPoints;
    private Boolean isActive;
    private Integer availableQuantity;
    private Boolean isLimited;
    private Boolean isSoldOut;
    private Integer initialQuantity;
    private Integer soldCount;
}