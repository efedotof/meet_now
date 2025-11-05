package com.efedotov.meet_now.meet_now.service.notification;

import java.util.UUID;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.util.TokenEncryptionService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class PushTokenService {

    private final UserRepository userRepository;
    private final TokenEncryptionService tokenEncryptionService;

    public void savePushTokenForCurrentUser(String pushToken, String userPassword) {
        UUID userId = getCurrentUserId();
        savePushToken(userId, pushToken, userPassword);
    }

    public void savePushToken(UUID userId, String pushToken, String userPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        try {
            String salt = tokenEncryptionService.generateSalt();
            String encryptedToken = tokenEncryptionService.encryptPushTokenWithSalt(
                    pushToken, userPassword, salt);

            user.setEncryptedPushToken(encryptedToken);
            user.setPushTokenSalt(salt);
            userRepository.save(user);

            log.info("Push token saved for user: {}", userId);

        } catch (Exception e) {
            log.error("Failed to encrypt and save push token for user: {}", userId, e);
            throw new RuntimeException("Failed to save push token", e);
        }
    }

    public String getDecryptedPushToken(UUID userId, String userPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (user.getEncryptedPushToken() == null) {
            return null;
        }

        try {
            return tokenEncryptionService.decryptPushTokenWithSalt(
                    user.getEncryptedPushToken(),
                    userPassword,
                    user.getPushTokenSalt());
        } catch (Exception e) {
            log.error("Failed to decrypt push token for user: {}", userId, e);
            throw new RuntimeException("Failed to decrypt push token", e);
        }
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