package com.efedotov.meet_now.meet_now.controller.auth;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.dto.response.social.LogoutResult;
import com.efedotov.meet_now.meet_now.dto.response.social.SessionCountResponse;
import com.efedotov.meet_now.meet_now.dto.response.social.SessionStatistics;
import com.efedotov.meet_now.meet_now.model.user.UserSession;
import com.efedotov.meet_now.meet_now.service.auth.SessionService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/auth/token")
@RequiredArgsConstructor
public class TokenValidationController {
    private final SessionService sessionService;

    @AdminOnly
    @GetMapping("/admin/sessions")
    @Operation(summary = "[ADMIN] Получить все активные сессии")
    public ResponseEntity<List<UserSession>> getAllActiveSessions() {
        List<UserSession> sessions = sessionService.getAllActiveSessions();
        return ResponseEntity.ok(sessions);
    }

    @AdminOnly
    @GetMapping("/admin/sessions/user/{userId}")
    @Operation(summary = "[ADMIN] Получить сессии пользователя")
    public ResponseEntity<List<UserSession>> getUserSessions(@PathVariable UUID userId) {
        List<UserSession> sessions = sessionService.getSessionsByUserId(userId);
        return ResponseEntity.ok(sessions);
    }

    @AdminOnly
    @GetMapping("/admin/sessions/count")
    @Operation(summary = "[ADMIN] Получить количество активных сессий")
    public ResponseEntity<SessionCountResponse> getActiveSessionsCount() {
        long count = sessionService.getActiveSessionsCount();
        SessionCountResponse response = new SessionCountResponse();
        response.setActiveSessionsCount(count);
        return ResponseEntity.ok(response);
    }

    @AdminOnly
    @DeleteMapping("/admin/sessions/{token}")
    @Operation(summary = "[ADMIN] Принудительно завершить сессию")
    public ResponseEntity<Void> forceLogout(@PathVariable String token) {
        sessionService.forceLogout(token);
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @DeleteMapping("/admin/sessions/user/{userId}")
    @Operation(summary = "[ADMIN] Завершить все сессии пользователя")
    public ResponseEntity<LogoutResult> forceLogoutAllUserSessions(@PathVariable UUID userId) {
        LogoutResult result = sessionService.forceLogoutAllUserSessions(userId);
        return ResponseEntity.ok(result);
    }

    @AdminOnly
    @GetMapping("/admin/sessions/statistics")
    @Operation(summary = "[ADMIN] Получить статистику по сессиям")
    public ResponseEntity<SessionStatistics> getSessionStatistics() {
        SessionStatistics statistics = sessionService.getSessionStatistics();
        return ResponseEntity.ok(statistics);
    }

    @AdminOnly
    @GetMapping("/admin/sessions/search")
    @Operation(summary = "[ADMIN] Поиск сессий по критериям")
    public ResponseEntity<List<UserSession>> searchSessions(
            @RequestParam(required = false) UUID userId,
            @RequestParam(required = false) String period) {
        List<UserSession> sessions = sessionService.searchSessions(userId, period);
        return ResponseEntity.ok(sessions);
    }

    @GetMapping("/validate-token")
    @Operation(summary = "Проверка токена")
    public ResponseEntity<?> validateToken(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Missing or invalid Authorization header");
        }

        String token = authHeader.substring(7);
        Optional<UserSession> session = sessionService.findValidSession(token);

        return session.isPresent()
                ? ResponseEntity.ok().build()
                : ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body("Invalid or expired token");
    }
}