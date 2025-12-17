package com.efedotov.meet_now.meet_now.dto.response.notification;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class NotificationHistoryStatsDto {
    private long totalNotifications;
    private long successfulNotifications;
    private long failedNotifications;
    private double successRate;
    private List<NotificationTypeStatDto> typeStatistics;
}