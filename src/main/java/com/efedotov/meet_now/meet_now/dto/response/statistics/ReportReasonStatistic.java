package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Data;

@Data
public class ReportReasonStatistic {
    private String reason;
    private Long count;
}
