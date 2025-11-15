package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class AdminGiftRarityDto {
    private UUID id;
    private String name;
    private String displayName;
    private String color;
    private Double multiplier;
    private Double probability;
    private Integer minPoints;
    private Integer maxPoints;
    private Boolean isActive;
    private LocalDateTime createdAt;
}