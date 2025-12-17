package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GiftDto {
    private UUID id;
    private String name;
    private String description;
    private String imageUrl;
    private String giftType;
    private GiftRarityDto rarity;
    private Integer costPoints;
    private String animationUrl;
    private Integer availableQuantity;
    private Boolean isLimited;
    private Boolean isSoldOut;
    private Integer soldCount;
}
