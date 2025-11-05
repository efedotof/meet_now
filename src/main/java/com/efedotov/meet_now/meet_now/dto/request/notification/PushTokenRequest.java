package com.efedotov.meet_now.meet_now.dto.request.notification;

import lombok.Data;

@Data
public class PushTokenRequest {
    private String pushToken;
    private String password;
}