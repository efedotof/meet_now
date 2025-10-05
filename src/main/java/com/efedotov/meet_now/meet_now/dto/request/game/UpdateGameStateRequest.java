package com.efedotov.meet_now.meet_now.dto.request.game;

import lombok.Data;

@Data
public class UpdateGameStateRequest {
    private String newState;
}