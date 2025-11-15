package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AgeGroupStatisticDto {
    private String ageGroup;
    private Long count;
}