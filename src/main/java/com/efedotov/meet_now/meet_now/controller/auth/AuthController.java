package com.efedotov.meet_now.meet_now.controller.auth;

import com.efedotov.meet_now.meet_now.dto.LoginDTO;
import com.efedotov.meet_now.meet_now.dto.RegistrationDTO;
import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.service.AuthService;

import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.web.bind.annotation.RequestBody;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "Auth", description = "Эндпоинты для регистрации, входа, выхода и управления аутентификацией")
@RequiredArgsConstructor

public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
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
}
