package com.efedotov.meet_now.meet_now.service.notification;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.google.firebase.messaging.BatchResponse;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.MulticastMessage;
import com.google.firebase.messaging.Notification;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class FCMNotificationService {

    private final PushTokenService pushTokenService;
    private final UserRepository userRepository;
    private final NotificationStatisticsService notificationStatisticsService;

    @AdminOnly
    public void sendNotificationToUser(UUID userId, String message, String title) {
        try {
            String pushToken = pushTokenService.getDecryptedPushToken(userId);
            if (pushToken != null) {
                sendNotificationToToken(pushToken, message, title);

                notificationStatisticsService.logNotification(
                        userId, title, message, "user", true, null);

                log.info("FCM notification sent to user: {}", userId);
            } else {
                notificationStatisticsService.logNotification(
                        userId, title, message, "user", false, "No push token found");
                log.warn("No push token found for user: {}", userId);
            }
        } catch (Exception e) {
            notificationStatisticsService.logNotification(
                    userId, title, message, "user", false, e.getMessage());
            log.error("Failed to send FCM notification to user: {}", userId, e);
            throw new RuntimeException("Failed to send FCM notification", e);
        }
    }

    @AdminOnly
    public void sendAllNotificationToAllUser(String message, String title) {
        try {
            List<User> usersWithTokens = userRepository.findByEncryptedPushTokenIsNotNull();

            if (usersWithTokens.isEmpty()) {
                log.warn("No users with push tokens found");
                return;
            }

            List<String> tokens = usersWithTokens.stream()
                    .map(User::getEncryptedPushToken)
                    .collect(Collectors.toList());

            log.info("Sending notification to {} users", tokens.size());

            sendMulticastNotification(tokens, message, title);

            for (User user : usersWithTokens) {
                notificationStatisticsService.logNotification(
                        user.getId(), title, message, "multicast", true, null);
            }

        } catch (Exception e) {
            log.error("Failed to send FCM notification to all users", e);
            throw new RuntimeException("Failed to send FCM notification to all users", e);
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

    public void sendDataNotificationToToken(String pushToken, String message, String title,
            Map<String, String> data) {
        try {
            Message fcmMessage = Message.builder()
                    .setToken(pushToken)
                    .setNotification(Notification.builder()
                            .setTitle(title != null ? title : "New Notification")
                            .setBody(message)
                            .build())
                    .putAllData(data)
                    .putData("timestamp", String.valueOf(System.currentTimeMillis()))
                    .build();

            String response = FirebaseMessaging.getInstance().send(fcmMessage);
            log.debug("FCM notification with data sent to token: {}, response: {}", pushToken, response);

        } catch (FirebaseMessagingException e) {
            log.error("Failed to send FCM data notification to token: {}", pushToken, e);
            throw new RuntimeException("FCM data notification failed", e);
        }
    }

    public void sendMulticastNotification(List<String> tokens, String message, String title) {
        try {
            int batchSize = 500;
            int successCount = 0;
            int failureCount = 0;

            for (int i = 0; i < tokens.size(); i += batchSize) {
                int end = Math.min(tokens.size(), i + batchSize);
                List<String> batchTokens = tokens.subList(i, end);

                try {
                    MulticastMessage multicastMessage = MulticastMessage.builder()
                            .setNotification(Notification.builder()
                                    .setTitle(title != null ? title : "Broadcast Notification")
                                    .setBody(message)
                                    .build())
                            .addAllTokens(batchTokens)
                            .putData("timestamp", String.valueOf(System.currentTimeMillis()))
                            .putData("type", "broadcast")
                            .build();

                    BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(multicastMessage);
                    successCount += response.getSuccessCount();
                    failureCount += response.getFailureCount();

                } catch (FirebaseMessagingException e) {
                    failureCount += batchTokens.size();
                    log.error("Failed to send batch starting at index {}", i, e);
                }
            }

            log.info("FCM multicast notification completed. Total: {}, Success: {}, Failed: {}",
                    tokens.size(), successCount, failureCount);

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