package com.efedotov.meet_now.meet_now.dto.request.notification;

import lombok.Data;
import java.util.UUID;

@Data
public class NotificationLogRequest {
    private UUID userId;
    private String title;
    private String message;
    private String notificationType;
    private boolean success;
    private String errorMessage;
}