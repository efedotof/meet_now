package com.efedotov.meet_now.meet_now.dto.response.game;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

import com.efedotov.meet_now.meet_now.model.chat.ChatGame;

@Data
@Builder
public class GameExportResponse {
    private List<ChatGame> games;
    private Long totalGames;
    private Long gamesWithChat;
    private Long gamesWithoutChat;
    private List<GameTypeStatisticDto> gamesByType;
    private LocalDateTime exportTimestamp;
}
