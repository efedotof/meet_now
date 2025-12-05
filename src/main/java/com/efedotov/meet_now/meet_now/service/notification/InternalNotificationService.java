package com.efedotov.meet_now.meet_now.service.notification;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.service.chat.WebSocketSessionService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class InternalNotificationService {

    private final FCMNotificationService fcmNotificationService;
    private final PushTokenService pushTokenService;
    private final UserRepository userRepository;
    private final WebSocketSessionService webSocketSessionService;

    public void sendSystemNotification(UUID userId, String message, String title) {
        try {
            fcmNotificationService.sendNotificationToUser(userId, message, title);
            log.info("System notification sent to user: {}", userId);

        } catch (Exception e) {
            log.error("Failed to send system notification to user: {}", userId, e);
        }
    }

     public void sendNewMessageNotification(UUID recipientId, UUID senderId, String senderName, 
                                          String messagePreview, UUID chatId, UUID tempChatId, boolean isTemporary) {
        try {
            UUID targetChatId = isTemporary ? tempChatId : chatId;
            
            if (targetChatId != null && webSocketSessionService.isUserActiveInChat(recipientId, targetChatId)) {
                log.info("Пользователь {} активен в чате {}, уведомление не отправляется", 
                        recipientId, targetChatId);
                return;
            }
            
            User sender = userRepository.findById(senderId)
                    .orElseThrow(() -> new RuntimeException("Sender not found"));

            String avatarUrl = sender.getAvatar();
            
            String displayName = isTemporary ? "Анонимный пользователь" : senderName;
            String title = displayName;
            String message = messagePreview.length() > 100 ? messagePreview.substring(0, 100) + "..." : messagePreview;

            Map<String, String> data = new HashMap<>();
            data.put("type", "new_message");
            data.put("senderId", senderId.toString());
            data.put("senderName", displayName); 
            data.put("isTemporary", String.valueOf(isTemporary));
            data.put("action", "open_chat");
            
            if (chatId != null) {
                data.put("chatId", chatId.toString());
            }
            if (tempChatId != null) {
                data.put("tempChatId", tempChatId.toString());
            }

            if (avatarUrl != null && !avatarUrl.trim().isEmpty() && !isTemporary) {
                data.put("avatarUrl", avatarUrl);
                data.put("image", avatarUrl);
            }

            String pushToken = pushTokenService.getDecryptedPushToken(recipientId);
            if (pushToken != null) {
                fcmNotificationService.sendDataNotificationToToken(pushToken, message, title, data);
                log.info("New message notification sent to user: {}, temporary: {}, chatId: {}", 
                        recipientId, isTemporary, targetChatId);
            } else {
                log.warn("No push token found for user: {}", recipientId);
            }

        } catch (Exception e) {
            log.error("Failed to send new message notification to user: {}", recipientId, e);
        }
    }

    public void sendFriendRequestNotification(UUID recipientId, UUID senderId, String senderName) {
        try {
            User sender = userRepository.findById(senderId)
                    .orElseThrow(() -> new RuntimeException("Sender not found"));

            String avatarUrl = sender.getAvatar();
            String title = "Новый запрос в друзья";
            String message = senderName + " хочет быть твоим другом";

            Map<String, String> data = new HashMap<>();
            data.put("type", "friend_request");
            data.put("senderId", senderId.toString());
            data.put("senderName", senderName);
            data.put("action", "view_friend_requests");

            if (avatarUrl != null && !avatarUrl.trim().isEmpty()) {
                data.put("avatarUrl", avatarUrl);
                data.put("image", avatarUrl);
            }

            String pushToken = pushTokenService.getDecryptedPushToken(recipientId);
            if (pushToken != null) {
                fcmNotificationService.sendDataNotificationToToken(pushToken, message, title, data);
                log.info("Friend request notification sent to user: {}", recipientId);
            }

        } catch (Exception e) {
            log.error("Failed to send friend request notification to user: {}", recipientId, e);
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