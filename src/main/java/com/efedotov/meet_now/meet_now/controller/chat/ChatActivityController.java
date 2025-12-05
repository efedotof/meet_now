package com.efedotov.meet_now.meet_now.controller.chat;

import com.efedotov.meet_now.meet_now.dto.request.chat.ChatActivityRequest;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.chat.WebSocketSessionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import java.util.UUID;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatActivityController {

    private final WebSocketSessionService webSocketSessionService;

    @MessageMapping("/chat.opened")
    public void handleChatOpened(@Payload ChatActivityRequest request,
            SimpMessageHeaderAccessor headerAccessor, Authentication authentication) {
        try {
            String sessionId = headerAccessor.getSessionId();
            UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();

            UUID chatId = request.getChatId() != null ? request.getChatId() : request.getTempChatId();

            if (userId != null && chatId != null && sessionId != null) {
                webSocketSessionService.addActiveChatForSession(sessionId, userId, chatId);
                log.info("Пользователь {} открыл чат {} (сессия: {})", userId, chatId, sessionId);
            }
        } catch (Exception e) {
            log.error("Ошибка при обработке открытия чата", e);
        }
    }

    @MessageMapping("/chat.closed")
    public void handleChatClosed(@Payload ChatActivityRequest request,
            SimpMessageHeaderAccessor headerAccessor, Authentication authentication) {
        try {
            String sessionId = headerAccessor.getSessionId();
            UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
            UUID chatId = request.getChatId() != null ? request.getChatId() : request.getTempChatId();

            if (userId != null && chatId != null && sessionId != null) {
                webSocketSessionService.removeActiveChatForSession(sessionId, userId, chatId);
                log.info("Пользователь {} закрыл чат {} (сессия: {})", userId, chatId, sessionId);
            }
        } catch (Exception e) {
            log.error("Ошибка при обработке закрытия чата", e);
        }
    }
}