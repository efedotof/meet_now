package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserGrowthStatisticsDto {
    private String period;
    private LocalDate startDate;
    private LocalDate endDate;
    private Long totalGrowth;
    private List<DailyUserGrowthDto> dailyData;
}