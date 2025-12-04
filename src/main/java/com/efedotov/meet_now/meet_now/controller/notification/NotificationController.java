package com.efedotov.meet_now.meet_now.controller.notification;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.notification.NotificationRequest;
import com.efedotov.meet_now.meet_now.dto.request.notification.PushTokenRequest;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.notification.FCMNotificationService;
import com.efedotov.meet_now.meet_now.service.notification.PushTokenService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final FCMNotificationService notificationService;
    private final PushTokenService pushTokenService;

    @AdminOnly
    @PostMapping("/token/{pushToken}")
    public ResponseEntity<?> sendTokenNotification(
            @PathVariable String pushToken,
            @RequestBody NotificationRequest request) {

        notificationService.sendNotificationToToken(pushToken, request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @PostMapping("/user/{userId}")
    public ResponseEntity<?> sendUserNotification(
            @PathVariable UUID userId,
            @RequestBody NotificationRequest request) {

        notificationService.sendNotificationToUser(userId, request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @PostMapping("/user/allUserNotifications")
    public ResponseEntity<?> sendAllUserNotification(@RequestBody NotificationRequest request){
        notificationService.sendAllNotificationToAllUser(request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/register-token")
    public ResponseEntity<?> registerPushToken(
            @RequestBody PushTokenRequest request) {

        pushTokenService.savePushTokenForCurrentUser(request.getPushToken());
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/unregister-token")
    public ResponseEntity<?> unregisterPushToken() {
        pushTokenService.removePushTokenForCurrentUser();
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @PostMapping("/data/{pushToken}")
    public ResponseEntity<?> sendDataNotification(
            @PathVariable String pushToken,
            @RequestBody NotificationRequest request) {

        java.util.Map<String, String> data = new java.util.HashMap<>();
        data.put("type", "system");
        data.put("action", request.getAction() != null ? request.getAction() : "info");

        notificationService.sendDataNotificationToToken(pushToken, request.getMessage(),
                request.getTitle(), data);
        return ResponseEntity.ok().build();
    }
}