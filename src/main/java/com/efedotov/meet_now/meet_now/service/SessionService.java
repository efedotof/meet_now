package com.efedotov.meet_now.meet_now.service;

import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.UserSession;
import com.efedotov.meet_now.meet_now.repository.UserSessionRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SessionService {
    private final UserSessionRepository sessionRepository;

    private static final long SESSION_DURATION_HOURS = 12;

    public UserSession createSession(UUID userId) {
        String token = generateOpaqueToken();

        UserSession session = UserSession.builder()
                .token(token)
                .userId(userId)
                .createdAt(Instant.now())
                .expiresAt(Instant.now().plus(SESSION_DURATION_HOURS, ChronoUnit.HOURS))
                .build();

        return sessionRepository.save(session);
    }

    public Optional<UserSession> findByToken(String token) {
        return sessionRepository.findById(token)
                .filter(session -> session.getExpiresAt().isAfter(Instant.now()));
    }

    public void deleteSession(String token) {
        sessionRepository.deleteById(token);
    }

    private String generateOpaqueToken() {
        byte[] randomBytes = new byte[32];
        new SecureRandom().nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

}
