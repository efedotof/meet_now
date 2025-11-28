package com.efedotov.meet_now.meet_now.dto.request.notification;

import lombok.Data;

@Data
public class NotificationRequest {
    private String message;
    private String title;
    private String action; 
}