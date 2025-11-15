package com.efedotov.meet_now.meet_now.dto.request.game;

import lombok.Data;
import java.util.UUID;

@Data
public class BulkGameUpdateRequest {
    private UUID gameId;
    private String newState;
    private String gameType;
}