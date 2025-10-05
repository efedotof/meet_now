package com.efedotov.meet_now.meet_now.dto.request.game;

import java.util.UUID;

import lombok.Data;

@Data
public class AddGameRequest {
    private UUID chatId;
    private String gameType;
    private String initialState;
}
