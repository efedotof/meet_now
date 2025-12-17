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
public class GiftRarityDto {
    private UUID id;
    private String name;
    private String displayName;
    private String color;
    private Double multiplier;
    private Double probability;
    private Integer minPoints;
    private Integer maxPoints;
    private Boolean isActive;
}
