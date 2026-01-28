package com.efedotov.meet_now.meet_now.dto.response.search;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserWaitingTimeDto {
    private UUID userId;
    private long waitingMinutes;
}