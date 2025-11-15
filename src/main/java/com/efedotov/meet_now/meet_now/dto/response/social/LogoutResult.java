package com.efedotov.meet_now.meet_now.dto.response.social;

import java.util.UUID;

import lombok.Data;

@Data
public class LogoutResult {
    private UUID userId;
    private int sessionsTerminated;
    private String message;
}
