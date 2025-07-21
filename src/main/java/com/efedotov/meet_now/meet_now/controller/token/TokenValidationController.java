package com.efedotov.meet_now.meet_now.controller.token;

import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.model.UserSession;
import com.efedotov.meet_now.meet_now.service.auth.SessionService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/auth/token")
@RequiredArgsConstructor
public class TokenValidationController {
    private final SessionService sessionService;


    @GetMapping("/validate-token")
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
