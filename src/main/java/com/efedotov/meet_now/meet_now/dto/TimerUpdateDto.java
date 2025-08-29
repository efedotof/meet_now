package com.efedotov.meet_now.meet_now.dto;

import java.util.UUID;

import lombok.Data;

@Data
public class TimerUpdateDto {
    private UUID tempChatId;
    private long remainingTime;
    private boolean isFinished;
}