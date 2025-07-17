package com.efedotov.meet_now.meet_now.dto.request;

import java.util.UUID;

import lombok.Data;

@Data
public class CreateTemporaryChatRequest {
    private UUID senderId;
    private UUID recipientId;
    private int durationMinutes = 10;
}
