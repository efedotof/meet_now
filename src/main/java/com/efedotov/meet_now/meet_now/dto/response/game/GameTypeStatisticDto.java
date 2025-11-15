package com.efedotov.meet_now.meet_now.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameTypeStatisticDto {
    private String gameType;
    private Long count;
}