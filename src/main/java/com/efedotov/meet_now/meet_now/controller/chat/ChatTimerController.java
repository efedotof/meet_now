package com.efedotov.meet_now.meet_now.controller.chat;

import java.util.UUID;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.efedotov.meet_now.meet_now.dto.AddTimeProposalDto;
import com.efedotov.meet_now.meet_now.dto.AddTimeResponseDto;
import com.efedotov.meet_now.meet_now.service.chat.ChatTimerManagementService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatTimerController {

    private final ChatTimerManagementService chatTimerManagementService;
    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat/{tempChatId}/propose-add-time")
    public void proposeAddTime(@DestinationVariable UUID tempChatId,
            @Payload AddTimeProposalDto proposal) {
        log.info("Получено предложение добавить время для чата {}: {} минут",
                tempChatId, proposal.getAdditionalMinutes());

        // Отправляем предложение другому пользователю
        messagingTemplate.convertAndSend(
                "/topic/chat/" + tempChatId + "/add-time-proposal",
                proposal);
    }

    @MessageMapping("/chat/{tempChatId}/respond-add-time")
    public void respondToAddTime(@DestinationVariable UUID tempChatId,
            @Payload AddTimeResponseDto response) {
        log.info("Получен ответ на предложение добавить время для чата {}: {}",
                tempChatId, response.isAccepted() ? "принято" : "отклонено");

        if (response.isAccepted()) {
            // Добавляем время к таймеру через management service
            chatTimerManagementService.addTimeToTimer(tempChatId, response.getAdditionalMinutes());

            // Уведомляем обоих пользователей об обновлении таймера
            messagingTemplate.convertAndSend(
                    "/topic/chat/" + tempChatId + "/time-added",
                    response);
        } else {
            // Уведомляем об отказе
            messagingTemplate.convertAndSend(
                    "/topic/chat/" + tempChatId + "/time-rejected",
                    response);
        }
    }
}