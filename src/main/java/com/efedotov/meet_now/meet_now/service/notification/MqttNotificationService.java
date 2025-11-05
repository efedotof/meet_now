package com.efedotov.meet_now.meet_now.service.notification;

import java.util.UUID;

import org.springframework.integration.mqtt.outbound.MqttPahoMessageHandler;
import org.springframework.integration.mqtt.support.MqttHeaders;
import org.springframework.messaging.Message;
import org.springframework.messaging.support.MessageBuilder;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.notification.NotificationDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MqttNotificationService {

    private final MqttPahoMessageHandler mqttMessageHandler;
    private final PushTokenService pushTokenService;

    public void sendNotificationToUser(UUID userId, String message, String title, String userPassword) {
        try {
            String pushToken = pushTokenService.getDecryptedPushToken(userId, userPassword);
            if (pushToken != null) {
                sendNotificationToToken(pushToken, message, title);
                log.info("Notification sent to user: {}", userId);
            } else {
                log.warn("No push token found for user: {}", userId);
            }
        } catch (Exception e) {
            log.error("Failed to send notification to user: {}", userId, e);
            throw new RuntimeException("Failed to send notification", e);
        }
    }

    public void sendNotificationToToken(String pushToken, String message, String title) {
        String topic = "tokens/" + pushToken + "/notifications";

        NotificationDto notification = createNotification(message, title != null ? title : "New Notification", "high");

        Message<String> mqttMessage = MessageBuilder
                .withPayload(notification.toJson())
                .setHeader(MqttHeaders.TOPIC, topic)
                .setHeader(MqttHeaders.QOS, 1)
                .build();

        mqttMessageHandler.handleMessage(mqttMessage);
        log.debug("Notification sent to token: {}", pushToken);
    }

    public void sendBroadcastNotification(String message, String title) {
        NotificationDto notification = createNotification(message, title != null ? title : "Broadcast", "normal");

        Message<String> mqttMessage = MessageBuilder
                .withPayload(notification.toJson())
                .setHeader(MqttHeaders.TOPIC, "notifications/broadcast")
                .setHeader(MqttHeaders.QOS, 0)
                .setHeader(MqttHeaders.RETAINED, true)
                .build();

        mqttMessageHandler.handleMessage(mqttMessage);
        log.info("Broadcast notification sent");
    }

    private NotificationDto createNotification(String message, String title, String priority) {
        NotificationDto notification = new NotificationDto();
        notification.setId(UUID.randomUUID().toString());
        notification.setTitle(title);
        notification.setBody(message);
        notification.setTimestamp(System.currentTimeMillis());
        notification.setPriority(priority);
        return notification;
    }

}