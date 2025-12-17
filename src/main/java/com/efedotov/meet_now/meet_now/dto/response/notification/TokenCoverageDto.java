package com.efedotov.meet_now.meet_now.dto.response.notification;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TokenCoverageDto {
    private long totalUsers;
    private long usersWithTokens;
    private long usersWithoutTokens;
    private long onlineUsersWithTokens;
    private long offlineUsersWithTokens;
    private double overallCoveragePercentage;
    private double onlineCoveragePercentage;
}