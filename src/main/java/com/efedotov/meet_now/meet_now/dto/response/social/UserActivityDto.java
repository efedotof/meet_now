package com.efedotov.meet_now.meet_now.dto.response.social;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Data;

@Data
public class UserActivityDto {
    private UUID userId;
    private String username;
    private UUID chatId; 
    private ActivityType activityType;
    private LocalDateTime timestamp;
    
    public enum ActivityType {
        TYPING,
        SENDING_IMAGE,
        SENDING_FILE,
        ONLINE,
        OFFLINE
    }
}