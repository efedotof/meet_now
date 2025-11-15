package com.efedotov.meet_now.meet_now.dto.response.moderation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportStatisticsDto {
    private Long totalReports;
    private Long sentReports;
    private Long inProcessReports;
    private Long completedReports;
}