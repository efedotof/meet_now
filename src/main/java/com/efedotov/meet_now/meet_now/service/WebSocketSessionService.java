package com.efedotov.meet_now.meet_now.service;

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

    public boolean hasActiveSessions(UUID userId) {
        Set<String> sessions = userSessionsMap.get(userId);
        return sessions != null && !sessions.isEmpty();
    }

    public UUID getUserIdBySessionId(String sessionId) {
        return sessionUserIdMap.get(sessionId);
    }
}