package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TemporaryChatDto {
    private UUID tempChatId;
    private UUID senderId;
    private UUID recipientId;
    private LocalDateTime createdAt;
    private Integer durationMinutes;
    private Boolean isFinished;
    private Boolean bothAgreed;
    private Boolean senderAgreed;
    private Boolean recipientAgreed;
    private String encryptedAesKey;
}