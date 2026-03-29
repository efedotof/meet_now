package com.efedotov.meet_now.meet_now.controller.app;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.keys.KeyUploadRequest;
import com.efedotov.meet_now.meet_now.dto.request.keys.SaltUploadRequest;
import com.efedotov.meet_now.meet_now.dto.response.keys.PublicKeyResponse;
import com.efedotov.meet_now.meet_now.dto.response.keys.SaltResponse;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.social.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/keys")
@Tag(name = "Keys", description = "Эндпоинты для управления RSA ключами пользователей")
@RequiredArgsConstructor
public class KeyController {

    private final UserService userService;

    @Operation(summary = "Загрузить свои RSA ключи", description = "Сохраняет публичный ключ и зашифрованный приватный ключ текущего пользователя")
    @PostMapping("/upload")
    public ResponseEntity<Void> uploadKeys(@RequestBody KeyUploadRequest request,
            Authentication authentication) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        userService.saveKeys(userId, request.getPublicKey(), request.getEncryptedPrivateKey());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/public/{userId}")
    public ResponseEntity<PublicKeyResponse> getPublicKey(@PathVariable UUID userId) {
        String publicKey = userService.getPublicKey(userId);
        if (publicKey == null) {
            return ResponseEntity.notFound().build();
        }
        PublicKeyResponse response = new PublicKeyResponse();
        response.setPublicKey(publicKey);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Загрузить свою соль", description = "Сохраняет соль для текущего пользователя")
    @PostMapping("/salt")
    public ResponseEntity<Void> uploadSalt(@RequestBody SaltUploadRequest request,
            Authentication authentication) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        userService.saveSalt(userId, request.getSalt());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/salt")
    public ResponseEntity<SaltResponse> getSalt(Authentication authentication) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        String salt = userService.getSalt(userId);
        if (salt == null) {
            return ResponseEntity.notFound().build();
        }
        SaltResponse response = new SaltResponse();
        response.setSalt(salt);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/encrypted")
    public ResponseEntity<String> getEncryptedPrivateKey(Authentication authentication) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        String encryptedPrivateKey = userService.getEncryptedPrivateKey(userId);
        if (encryptedPrivateKey == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(encryptedPrivateKey);
    }
}