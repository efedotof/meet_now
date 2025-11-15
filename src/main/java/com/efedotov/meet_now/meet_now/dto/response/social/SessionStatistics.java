package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.Data;

@Data
public class SessionStatistics {
    private long totalActiveSessions;
    private long totalSessionsToday;
    private long totalSessionsThisWeek;
    private long averageSessionsPerDay;
    private long maxConcurrentSessions;
}
