package com.efedotov.meet_now.meet_now.dto.response.game;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class CleanupResultResponse {
    private Long deletedGamesCount;
    private LocalDateTime cutoffDate;
    private String message;
}
