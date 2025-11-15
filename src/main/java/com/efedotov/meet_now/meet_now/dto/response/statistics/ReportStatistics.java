package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Data;

import java.util.List;

@Data
public class ReportStatistics {
    private long totalReports;
    private long sentReports;
    private long inProcessReports;
    private long completedReports;
    private List<ReportReasonStatistic> reportsByReason;
}