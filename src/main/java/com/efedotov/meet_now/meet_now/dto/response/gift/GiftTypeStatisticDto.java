package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GiftTypeStatisticDto {
    private String typeName;
    private Long count;
}