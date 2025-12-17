package com.efedotov.meet_now.meet_now.dto.response.notification;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class NotificationStatisticsDto {
    private long totalUsersWithPushTokens;
    private long onlineUsersWithPushTokens;
    private long offlineUsersWithPushTokens;
    private long totalRegisteredPushTokens;
    private double percentageUsersWithTokens;
    private long totalUsers;
}