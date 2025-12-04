package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class AdminGiftDto {
    private UUID id;
    private String name;
    private String description;
    private String imageUrl;
    private String giftType;
    private GiftRarityDto rarity;
    private Integer costPoints;
    private String animationUrl;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private Integer availableQuantity;
    private Boolean isLimited;
    private Boolean isSoldOut;
    private Integer initialQuantity;
    private Integer soldCount;
}