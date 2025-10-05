package com.efedotov.meet_now.meet_now.websocket;

import java.util.UUID;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.chat.WebSocketSessionService;
import com.efedotov.meet_now.meet_now.service.social.UserService;

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
            boolean hadActiveSessionsBefore = sessionService.hasActiveSessions(userId);
            sessionService.registerNewSession(sessionId, userId);

            if (!hadActiveSessionsBefore) {
                userService.setUserOnline(userId, true);
                log.info("УСТАНОВКА ONLINE: Пользователь {} переведён в онлайн (первая сессия)", userId);
            } else {
                log.debug("Пользователь {} остаётся онлайн (активных сессий: {})", 
                          userId, sessionService.getActiveSessionCount(userId));
            }

            log.info("Подключение: sessionId={}, userId={}, активных сессий={}", 
                     sessionId, userId, sessionService.getActiveSessionCount(userId));
        } else {
            log.warn("Не удалось получить аутентификацию, sessionId={}", sessionId);
        }
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = headerAccessor.getSessionId();
        UUID userId = sessionService.getUserIdBySessionId(sessionId);

        if (userId != null) {
            sessionService.removeSession(sessionId);
            int remainingSessions = sessionService.getActiveSessionCount(userId);
            
            if (remainingSessions == 0) {
                userService.setUserOnline(userId, false);
                log.info("УСТАНОВКА OFFLINE: Пользователь {} переведён в оффлайн", userId); 
            } else {
                log.debug("Пользователь {} остаётся онлайн (осталось сессий: {})", userId, remainingSessions);
            }

            log.info("Отключение: sessionId={}, userId={}, осталось сессий={}", 
                     sessionId, userId, remainingSessions);
        } else {
            log.warn("Не найден userId для сессии {}", sessionId);
        }
    }
}