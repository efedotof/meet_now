package com.efedotov.meet_now.meet_now.dto.request.gift;

import lombok.Data;

@Data
public class AdminCreateGiftRarityRequest {
    private String name;
    private String displayName;
    private String color;
    private Double multiplier;
    private Double probability;
    private Integer minPoints;
    private Integer maxPoints;
}