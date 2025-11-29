package com.efedotov.meet_now.meet_now.service.notification;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class InternalNotificationService {

    private final FCMNotificationService fcmNotificationService;
    private final PushTokenService pushTokenService;

    public void sendSystemNotification(UUID userId, String message, String title) {
        try {
            fcmNotificationService.sendNotificationToUser(userId, message, title);
            log.info("System notification sent to user: {}", userId);

        } catch (Exception e) {
            log.error("Failed to send system notification to user: {}", userId, e);
        }
    }

    public void sendNewMessageNotification(UUID recipientId, UUID senderId, String senderName, String messagePreview) {
        try {
            String title = "New message from " + senderName;
            String message = messagePreview.length() > 100 ? messagePreview.substring(0, 100) + "..." : messagePreview;

            Map<String, String> data = new HashMap<>();
            data.put("type", "new_message");
            data.put("senderId", senderId.toString());
            data.put("senderName", senderName);
            data.put("action", "open_chat");

            String pushToken = pushTokenService.getDecryptedPushToken(recipientId);
            if (pushToken != null) {
                fcmNotificationService.sendDataNotificationToToken(pushToken, message, title, data);
                log.info("New message notification sent to user: {}", recipientId);
            } else {
                log.warn("No push token found for user: {}", recipientId);
            }

        } catch (Exception e) {
            log.error("Failed to send new message notification to user: {}", recipientId, e);
        }
    }

    public void sendSystemDataNotification(UUID userId, String message, String title, Map<String, String> data) {
        try {
            String pushToken = pushTokenService.getDecryptedPushToken(userId);
            if (pushToken != null) {
                fcmNotificationService.sendDataNotificationToToken(pushToken, message, title, data);
                log.info("System data notification sent to user: {}", userId);
            } else {
                log.warn("No push token found for user: {}", userId);
            }

        } catch (Exception e) {
            log.error("Failed to send system data notification to user: {}", userId, e);
        }
    }
}