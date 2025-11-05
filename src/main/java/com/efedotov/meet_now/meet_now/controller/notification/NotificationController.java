package com.efedotov.meet_now.meet_now.controller.notification;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.notification.NotificationRequest;
import com.efedotov.meet_now.meet_now.dto.request.notification.PushTokenRequest;
import com.efedotov.meet_now.meet_now.service.notification.MqttNotificationService;
import com.efedotov.meet_now.meet_now.service.notification.PushTokenService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final MqttNotificationService notificationService;
    private final PushTokenService pushTokenService;

    @PostMapping("/token/{pushToken}")
    public ResponseEntity<?> sendTokenNotification(
            @PathVariable String pushToken,
            @RequestBody NotificationRequest request) {

        notificationService.sendNotificationToToken(pushToken, request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/broadcast")
    public ResponseEntity<?> sendBroadcastNotification(
            @RequestBody NotificationRequest request) {

        notificationService.sendBroadcastNotification(request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/register-token")
    public ResponseEntity<?> registerPushToken(
            @RequestBody PushTokenRequest request) {

        pushTokenService.savePushTokenForCurrentUser(request.getPushToken(), request.getPassword());
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/unregister-token")
    public ResponseEntity<?> unregisterPushToken() {
        pushTokenService.removePushTokenForCurrentUser();
        return ResponseEntity.ok().build();
    }
}