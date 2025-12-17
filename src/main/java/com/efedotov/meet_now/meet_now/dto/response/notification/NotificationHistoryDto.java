package com.efedotov.meet_now.meet_now.dto.response.notification;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class NotificationHistoryDto {
    private UUID id;
    private String title;
    private String message;
    private String notificationType;
    private UUID targetUserId;
    private String targetUsername;
    private LocalDateTime sentAt;
    private boolean success;
    private String errorMessage;
    private String status;
}