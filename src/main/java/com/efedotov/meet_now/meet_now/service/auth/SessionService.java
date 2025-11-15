package com.efedotov.meet_now.meet_now.service.auth;

import java.security.SecureRandom;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.dto.response.social.LogoutResult;
import com.efedotov.meet_now.meet_now.dto.response.social.SessionStatistics;
import com.efedotov.meet_now.meet_now.model.user.UserSession;
import com.efedotov.meet_now.meet_now.repository.user.UserSessionRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class SessionService {
    private final UserSessionRepository sessionRepository;

    private static final long SESSION_DURATION_HOURS = 12;

    @AdminOnly
    @Transactional(readOnly = true)
    public List<UserSession> getAllActiveSessions() {
        return sessionRepository.findAllActiveSessions(Instant.now());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<UserSession> getSessionsByUserId(UUID userId) {
        return sessionRepository.findByUserId(userId);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public long getActiveSessionsCount() {
        return sessionRepository.countActiveSessions(Instant.now());
    }

    @AdminOnly
    @Transactional
    public void forceLogout(String token) {
        if (sessionRepository.existsById(token)) {
            sessionRepository.deleteById(token);
            log.info("Администратор принудительно завершил сессию: {}", token);
        } else {
            log.warn("Попытка завершить несуществующую сессию: {}", token);
        }
    }

    @AdminOnly
    @Transactional
    public LogoutResult forceLogoutAllUserSessions(UUID userId) {
        List<UserSession> userSessions = sessionRepository.findByUserId(userId);
        int sessionsCount = userSessions.size();

        sessionRepository.deleteByUserId(userId);

        log.info("Администратор завершил все сессии пользователя {}. Завершено сессий: {}", userId, sessionsCount);

        LogoutResult result = new LogoutResult();
        result.setUserId(userId);
        result.setSessionsTerminated(sessionsCount);
        result.setMessage(String.format("Завершено %d сессий пользователя", sessionsCount));
        return result;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public SessionStatistics getSessionStatistics() {
        Instant now = Instant.now();
        Instant todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0)
                .atZone(ZoneId.systemDefault()).toInstant();
        Instant weekStart = todayStart.minus(7, ChronoUnit.DAYS);

        long totalActiveSessions = sessionRepository.countActiveSessions(now);
        long totalSessionsToday = sessionRepository.countSessionsCreatedAfter(todayStart);
        long totalSessionsThisWeek = sessionRepository.countSessionsCreatedAfter(weekStart);
        long averageSessionsPerDay = sessionRepository.getAverageSessionsPerDay();
        long maxConcurrentSessions = sessionRepository.getMaxConcurrentSessions();

        SessionStatistics statistics = new SessionStatistics();
        statistics.setTotalActiveSessions(totalActiveSessions);
        statistics.setTotalSessionsToday(totalSessionsToday);
        statistics.setTotalSessionsThisWeek(totalSessionsThisWeek);
        statistics.setAverageSessionsPerDay(averageSessionsPerDay);
        statistics.setMaxConcurrentSessions(maxConcurrentSessions);
        return statistics;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<UserSession> searchSessions(UUID userId, String period) {
        if (userId != null) {
            return sessionRepository.findByUserId(userId);
        }

        if (period != null) {
            Instant startTime = switch (period.toLowerCase()) {
                case "today" -> LocalDateTime.now().withHour(0).withMinute(0).withSecond(0)
                        .atZone(ZoneId.systemDefault()).toInstant();
                case "week" -> Instant.now().minus(7, ChronoUnit.DAYS);
                case "month" -> Instant.now().minus(30, ChronoUnit.DAYS);
                default -> Instant.now().minus(1, ChronoUnit.DAYS);
            };
            return sessionRepository.findSessionsCreatedAfter(startTime);
        }

        return sessionRepository.findAll();
    }

    @Transactional
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

    @AdminOnly
    @Transactional(readOnly = true)
    public Optional<UserSession> findByToken(String token) {
        return sessionRepository.findById(token)
                .filter(session -> session.getExpiresAt().isAfter(Instant.now()));
    }

    @AdminOnly
    @Transactional
    public void deleteSession(String token) {
        if (sessionRepository.existsById(token)) {
            sessionRepository.deleteById(token);
            log.info("Сессия {} завершена", token);
        }
    }

    private String generateOpaqueToken() {
        byte[] randomBytes = new byte[32];
        new SecureRandom().nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

    @Transactional(readOnly = true)
    public Optional<UserSession> findValidSession(String token) {
        return sessionRepository.findValidSession(token, Instant.now());
    }

    @Transactional
    @Scheduled(fixedRate = 86400000)
    public void cleanExpiredSessions() {
        sessionRepository.deleteExpiredSessions(Instant.now());
        log.info("Очистка просроченных сессий выполнена");
    }
}