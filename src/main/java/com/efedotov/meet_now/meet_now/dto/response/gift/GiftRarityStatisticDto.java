package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GiftRarityStatisticDto {
    private String rarityName;
    private Long count;
}