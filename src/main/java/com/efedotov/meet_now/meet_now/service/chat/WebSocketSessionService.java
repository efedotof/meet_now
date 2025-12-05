package com.efedotov.meet_now.meet_now.service.chat;

import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Component
public class WebSocketSessionService {
    private final ConcurrentMap<String, UUID> sessionUserIdMap = new ConcurrentHashMap<>();
    private final ConcurrentMap<UUID, Set<String>> userSessionsMap = new ConcurrentHashMap<>();
    private final ConcurrentMap<UUID, Set<UUID>> userActiveChatsMap = new ConcurrentHashMap<>();
    private final ConcurrentMap<String, Set<UUID>> sessionChatsMap = new ConcurrentHashMap<>();

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

            removeAllChatsForSession(sessionId, userId);
        }
    }

    public void addActiveChat(UUID userId, UUID chatId) {
        userActiveChatsMap.compute(userId, (key, chats) -> {
            if (chats == null) {
                chats = ConcurrentHashMap.newKeySet();
            }
            chats.add(chatId);
            return chats;
        });
    }

    public void removeActiveChat(UUID userId, UUID chatId) {
        userActiveChatsMap.computeIfPresent(userId, (key, chats) -> {
            chats.remove(chatId);
            return chats.isEmpty() ? null : chats;
        });
    }

    public boolean isUserActiveInChat(UUID userId, UUID chatId) {
        Set<UUID> activeChats = userActiveChatsMap.get(userId);
        return activeChats != null && activeChats.contains(chatId);
    }

    private void removeAllChatsForSession(String sessionId, UUID userId) {
        Set<UUID> sessionChats = sessionChatsMap.remove(sessionId);

        if (sessionChats != null && !sessionChats.isEmpty()) {
            for (UUID chatId : sessionChats) {
                boolean hasOtherSessionsInChat = false;

                Set<String> userSessions = userSessionsMap.get(userId);
                if (userSessions != null && !userSessions.isEmpty()) {
                    for (String userSessionId : userSessions) {
                        if (!userSessionId.equals(sessionId)) {
                            Set<UUID> userSessionChats = sessionChatsMap.get(userSessionId);
                            if (userSessionChats != null && userSessionChats.contains(chatId)) {
                                hasOtherSessionsInChat = true;
                                break;
                            }
                        }
                    }
                }

                if (!hasOtherSessionsInChat) {
                    removeActiveChat(userId, chatId);
                }
            }
        }
    }

    public void addActiveChatForSession(String sessionId, UUID userId, UUID chatId) {
        sessionChatsMap.compute(sessionId, (key, chats) -> {
            if (chats == null) {
                chats = ConcurrentHashMap.newKeySet();
            }
            chats.add(chatId);
            return chats;
        });

        addActiveChat(userId, chatId);
    }

    public void removeActiveChatForSession(String sessionId, UUID userId, UUID chatId) {
        sessionChatsMap.computeIfPresent(sessionId, (key, chats) -> {
            chats.remove(chatId);
            return chats.isEmpty() ? null : chats;
        });

        boolean hasOtherSessionsInChat = false;
        Set<String> userSessions = userSessionsMap.get(userId);

        if (userSessions != null && !userSessions.isEmpty()) {
            for (String userSessionId : userSessions) {
                if (!userSessionId.equals(sessionId)) {
                    Set<UUID> userSessionChats = sessionChatsMap.get(userSessionId);
                    if (userSessionChats != null && userSessionChats.contains(chatId)) {
                        hasOtherSessionsInChat = true;
                        break;
                    }
                }
            }
        }

        if (!hasOtherSessionsInChat) {
            removeActiveChat(userId, chatId);
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

    public Set<UUID> getActiveChatsForUser(UUID userId) {
        return userActiveChatsMap.get(userId);
    }

    public Set<UUID> getActiveChatsForSession(String sessionId) {
        return sessionChatsMap.get(sessionId);
    }
}