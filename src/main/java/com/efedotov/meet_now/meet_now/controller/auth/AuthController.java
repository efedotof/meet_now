package com.efedotov.meet_now.meet_now.controller.auth;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.LoginDTO;
import com.efedotov.meet_now.meet_now.dto.RegistrationDTO;
import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.service.auth.AuthService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "Auth", description = "Эндпоинты для регистрации, входа, выхода и управления аутентификацией")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
     @Operation(summary = "Регистрация в систему")
    public ResponseEntity<?> registration(@RequestBody RegistrationDTO dto) {
        try {
            System.out.println("Password from DTO: " + dto.getPassword());
            UserDto userDto = authService.register(dto);
            
            return ResponseEntity.ok(userDto);
        } catch (RuntimeException e) {
            return ResponseEntity.status(409).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Что-то пошло не так: " + e.getMessage());
        }
    }

    @PostMapping("/login")
     @Operation(summary = "Вход в систему")
    public ResponseEntity<?> login(@RequestBody LoginDTO dto) {
        try {
            UserDto userDto = authService.login(dto);
            return ResponseEntity.ok(userDto);
        } catch (RuntimeException e) {
            return ResponseEntity.status(401).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Ошибка при входе: " + e.getMessage());
        }
    }

    @PostMapping("/logout")
     @Operation(summary = "Выход из системы")
    public ResponseEntity<?> logout(@RequestHeader("Authorization") String authHeader) {
        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return ResponseEntity.status(401).body("Invalid authorization header");
            }

            String token = authHeader.substring(7);
            authService.logout(token);
            return ResponseEntity.ok("Logged out successfully");

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Logout failed: " + e.getMessage());
        }
    }

}
