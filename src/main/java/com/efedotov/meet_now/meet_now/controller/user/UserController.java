package com.efedotov.meet_now.meet_now.controller.user;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/v1/user")
@Tag(name = "User", description = "Эндпоинты для управления пользователями: получение профиля, обновление анкеты, управление приватностью")
public class UserController {
    
}
