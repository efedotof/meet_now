package com.efedotov.meet_now.meet_now.service.websocket;

import org.springframework.stereotype.Component;

import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Component
public class WebSocketSessionService {
    private final ConcurrentMap<String, UUID> sessionUserIdMap = new ConcurrentHashMap<>();
    private final ConcurrentMap<UUID, Set<String>> userSessionsMap = new ConcurrentHashMap<>();

    public void registerNewSession(String sessionId, UUID userId) {
        sessionUserIdMap.put(sessionId, userId);
        userSessionsMap.compute(userId, (key, sessions) -> {
            if (sessions == null) {
                sessions = ConcurrentHashMap.newKeySet();
            }
            sessions.add(sessionId);
            return sessions;
        });
    }

    public void removeSession(String sessionId) {
        UUID userId = sessionUserIdMap.remove(sessionId);
        if (userId != null) {
            userSessionsMap.computeIfPresent(userId, (key, sessions) -> {
                sessions.remove(sessionId);
                return sessions.isEmpty() ? null : sessions;
            });
        }
    }

    public int getActiveSessionCount(UUID userId) {
        Set<String> sessions = userSessionsMap.get(userId);
        return sessions != null ? sessions.size() : 0;
    }


    public boolean hasActiveSessions(UUID userId) {
        return getActiveSessionCount(userId) > 0;
    }

    public UUID getUserIdBySessionId(String sessionId) {
        return sessionUserIdMap.get(sessionId);
    }
}