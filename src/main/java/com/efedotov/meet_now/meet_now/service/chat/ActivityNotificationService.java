package com.efedotov.meet_now.meet_now.service.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.social.UserActivityDto;

import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ActivityNotificationService {

    private final SimpMessagingTemplate messagingTemplate;

    public void sendActivityNotification(UserActivityDto activityDto) {
        UUID chatId = activityDto.getChatId();
        String topic = "/topic/chat.activity." + chatId;
        messagingTemplate.convertAndSend(topic, activityDto);
        log.info("Sent activity notification: {} for chat {}", activityDto.getActivityType(), chatId);
    }
}