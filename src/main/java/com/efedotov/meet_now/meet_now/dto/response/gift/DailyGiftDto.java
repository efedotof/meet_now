package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class DailyGiftDto {
    private UUID id;
    private UUID userId;
    private GiftDto gift;
    private LocalDateTime receivedAt;
    private Integer streakCount;
}