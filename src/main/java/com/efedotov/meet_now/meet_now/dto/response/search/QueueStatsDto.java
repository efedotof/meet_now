package com.efedotov.meet_now.meet_now.dto.response.search;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QueueStatsDto {
    private int totalActiveSearches;
    private int totalQueues;
    private List<QueueSizeDto> queueSizes;
    private List<UserWaitingTimeDto> waitingTimes;
}