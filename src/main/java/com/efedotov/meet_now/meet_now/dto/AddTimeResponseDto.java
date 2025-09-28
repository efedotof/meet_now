package com.efedotov.meet_now.meet_now.dto;

import java.util.UUID;

import lombok.Data;

@Data
public class AddTimeResponseDto {
    private UUID tempChatId;
    private UUID userId;
    private boolean accepted;
    private int additionalMinutes;
}