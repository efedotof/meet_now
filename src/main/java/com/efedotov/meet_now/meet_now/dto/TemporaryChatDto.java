package com.efedotov.meet_now.meet_now.dto;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.Data;

@Data
public class TemporaryChatDto {
    private UUID tempChatId;
    private UUID senderId;
    private UUID recipientId;
    private LocalDateTime createdAt;
    private Integer durationMinutes;
    private Boolean isFinished;
    private Boolean bothAgreed;
}
