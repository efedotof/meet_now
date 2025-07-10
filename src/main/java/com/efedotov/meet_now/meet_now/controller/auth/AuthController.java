package com.efedotov.meet_now.meet_now.controller.auth;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "Auth", description = "Эндпоинты для регистрации, входа, выхода и управления аутентификацией")
public class AuthController {
    
}
