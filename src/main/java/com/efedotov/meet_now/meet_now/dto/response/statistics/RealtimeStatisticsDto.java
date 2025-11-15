package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RealtimeStatisticsDto {
    private Long onlineUsers;
    private Long searchingUsers;
    private Long activeChats;
    private Long activeTemporaryChats;
    private Long activeSessions;
    private Double systemUptimeHours;
    private LocalDateTime timestamp;
}