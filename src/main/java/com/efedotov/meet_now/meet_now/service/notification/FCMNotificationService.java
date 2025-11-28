package com.efedotov.meet_now.meet_now.service.notification;

import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class FCMNotificationService {

    private final PushTokenService pushTokenService;

    @AdminOnly
    public void sendNotificationToUser(UUID userId, String message, String title, String userPassword) {
        try {
            String pushToken = pushTokenService.getDecryptedPushToken(userId, userPassword);
            if (pushToken != null) {
                sendNotificationToToken(pushToken, message, title);
                log.info("FCM notification sent to user: {}", userId);
            } else {
                log.warn("No push token found for user: {}", userId);
            }
        } catch (Exception e) {
            log.error("Failed to send FCM notification to user: {}", userId, e);
            throw new RuntimeException("Failed to send FCM notification", e);
        }
    }

    public void sendNotificationToToken(String pushToken, String message, String title) {
        try {
            Message fcmMessage = Message.builder()
                    .setToken(pushToken)
                    .setNotification(Notification.builder()
                            .setTitle(title != null ? title : "New Notification")
                            .setBody(message)
                            .build())
                    .putData("timestamp", String.valueOf(System.currentTimeMillis()))
                    .putData("priority", "high")
                    .build();

            String response = FirebaseMessaging.getInstance().send(fcmMessage);
            log.debug("FCM notification sent to token: {}, response: {}", pushToken, response);

        } catch (FirebaseMessagingException e) {
            log.error("Failed to send FCM notification to token: {}", pushToken, e);
            throw new RuntimeException("FCM notification failed", e);
        }
    }

    @AdminOnly
    public void sendDataNotificationToToken(String pushToken, String message, String title,
            Map<String, String> data) {
        try {
            Message.Builder messageBuilder = Message.builder()
                    .setToken(pushToken)
                    .putData("title", title != null ? title : "New Notification")
                    .putData("body", message)
                    .putData("timestamp", String.valueOf(System.currentTimeMillis()));

            if (data != null) {
                data.forEach(messageBuilder::putData);
            }

            String response = FirebaseMessaging.getInstance().send(messageBuilder.build());
            log.debug("FCM data notification sent to token: {}, response: {}", pushToken, response);

        } catch (FirebaseMessagingException e) {
            log.error("Failed to send FCM data notification to token: {}", pushToken, e);
            throw new RuntimeException("FCM data notification failed", e);
        }
    }

    public void sendMulticastNotification(java.util.List<String> tokens, String message, String title) {
        try {
            int successCount = 0;
            int failureCount = 0;

            for (String token : tokens) {
                try {
                    Message individualMessage = Message.builder()
                            .setToken(token)
                            .setNotification(Notification.builder()
                                    .setTitle(title != null ? title : "Broadcast Notification")
                                    .setBody(message)
                                    .build())
                            .putData("timestamp", String.valueOf(System.currentTimeMillis()))
                            .build();

                    FirebaseMessaging.getInstance().send(individualMessage);
                    successCount++;

                } catch (FirebaseMessagingException e) {
                    log.error("Failed to send to token: {}", token, e);
                    failureCount++;
                }
            }

            log.info("FCM multicast notification completed. Success: {}, Failed: {}", successCount, failureCount);

        } catch (Exception e) {
            log.error("Failed to send FCM multicast notification", e);
            throw new RuntimeException("FCM multicast notification failed", e);
        }
    }

    public void sendMulticastDataNotification(java.util.List<String> tokens, String message, String title,
            Map<String, String> data) {
        try {
            int successCount = 0;
            int failureCount = 0;

            for (String token : tokens) {
                try {
                    Message.Builder messageBuilder = Message.builder()
                            .setToken(token)
                            .putData("title", title != null ? title : "Broadcast Notification")
                            .putData("body", message)
                            .putData("timestamp", String.valueOf(System.currentTimeMillis()));

                    if (data != null) {
                        data.forEach(messageBuilder::putData);
                    }

                    FirebaseMessaging.getInstance().send(messageBuilder.build());
                    successCount++;

                } catch (FirebaseMessagingException e) {
                    log.error("Failed to send data notification to token: {}", token, e);
                    failureCount++;
                }
            }

            log.info("FCM multicast data notification completed. Success: {}, Failed: {}", successCount, failureCount);

        } catch (Exception e) {
            log.error("Failed to send FCM multicast data notification", e);
            throw new RuntimeException("FCM multicast data notification failed", e);
        }
    }
}