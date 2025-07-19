package com.efedotov.meet_now.meet_now.websocket;

import java.util.UUID;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.UserService;
import com.efedotov.meet_now.meet_now.service.WebSocketSessionService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketEventListener {

    private final UserService userService;
    private final WebSocketSessionService sessionService;

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = headerAccessor.getSessionId();
        Authentication authentication = (Authentication) headerAccessor.getUser();

        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            UUID userId = userDetails.getUserId();

            sessionService.registerNewSession(sessionId, userId);
            
            // Установить онлайн только если это первая сессия
            if (!sessionService.hasActiveSessions(userId)) {
                userService.setUserOnline(userId, true);
            }

            log.info("Пользователь подключился, sessionId = {}, userId = {}", sessionId, userId);
        } else {
            log.warn("Не удалось получить аутентификацию при подключении, sessionId = {}", sessionId);
        }
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = headerAccessor.getSessionId();
        UUID userId = sessionService.getUserIdBySessionId(sessionId);

        if (userId != null) {
            sessionService.removeSession(sessionId);
            
            if (!sessionService.hasActiveSessions(userId)) {
                userService.setUserOnline(userId, false);
            }

            log.info("Пользователь отключился, sessionId = {}, userId = {}", sessionId, userId);
        } else {
            log.warn("Не удалось найти userId для сессии, sessionId = {}", sessionId);
        }
    }
}