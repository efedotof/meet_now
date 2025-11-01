package com.efedotov.meet_now.meet_now.controller.chat;

import java.util.UUID;

import org.springframework.messaging.MessagingException;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.efedotov.meet_now.meet_now.dto.request.chat.AddTimeProposalDto;
import com.efedotov.meet_now.meet_now.dto.request.chat.AddTimeResponseDto;
import com.efedotov.meet_now.meet_now.service.chat.ChatTimerManagementService;
import com.efedotov.meet_now.meet_now.service.chat.TemporaryChatService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatTimerController {

        private final ChatTimerManagementService chatTimerManagementService;
        private final TemporaryChatService temporaryChatService;
        private final SimpMessagingTemplate messagingTemplate;

        @MessageMapping("/chat/{tempChatId}/propose-add-time")
        public void proposeAddTime(@DestinationVariable UUID tempChatId,
                        @Payload AddTimeProposalDto proposal) {
                log.info("Получено предложение добавить время для чата {}: {} минут",
                                tempChatId, proposal.getAdditionalMinutes());

                if (!temporaryChatService.existsById(tempChatId)) {
                        log.warn("Чат {} не найден", tempChatId);
                        return;
                }

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
                        try {
                                chatTimerManagementService.addTimeToTimer(tempChatId, response.getAdditionalMinutes());

                                messagingTemplate.convertAndSend(
                                                "/topic/chat/" + tempChatId + "/time-added",
                                                response);

                                log.info("Время успешно добавлено к чату {}: +{} минут",
                                                tempChatId, response.getAdditionalMinutes());
                        } catch (MessagingException e) {
                                log.error("Ошибка при добавлении времени к чату {}: {}", tempChatId, e.getMessage());

                        }
                } else {
                        messagingTemplate.convertAndSend(
                                        "/topic/chat/" + tempChatId + "/time-rejected",
                                        response);
                }
        }
}