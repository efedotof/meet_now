package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyUserGrowthDto {
    private LocalDate date;
    private Long totalUsers;
    private Long newUsers;
}