package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Data;

@Data
public class SecondChanceDto {
    private UUID id;
    private UUID temporaryChatId;
    private Boolean senderDecision;
    private Boolean recipientDecision;
    private LocalDateTime createdAt;
    private Boolean processed;
}
