package com.efedotov.meet_now.meet_now.service.notification;

import java.util.UUID;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class PushTokenService {

    private final UserRepository userRepository;

    public void savePushTokenForCurrentUser(String pushToken) {
        UUID userId = getCurrentUserId();
        savePushToken(userId, pushToken);
    }

    public void savePushToken(UUID userId, String pushToken) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setEncryptedPushToken(pushToken);
        user.setPushTokenSalt(null); // Соль больше не нужна
        userRepository.save(user);

        log.info("Push token saved for user: {}", userId);
    }

    public String getDecryptedPushToken(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return user.getEncryptedPushToken(); // Просто возвращаем токен без расшифровки
    }

    public void removePushTokenForCurrentUser() {
        UUID userId = getCurrentUserId();
        removePushToken(userId);
    }

    public void removePushToken(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setEncryptedPushToken(null);
        user.setPushTokenSalt(null);
        userRepository.save(user);

        log.info("Push token removed for user: {}", userId);
    }

    private UUID getCurrentUserId() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof CustomUserDetails customUserDetails) {
            return customUserDetails.getUserId();
        } else {
            throw new RuntimeException("User not authenticated");
        }
    }
}