package com.efedotov.meet_now.meet_now.controller.icebreaker;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/v1/icebreaker")
@Tag(name = "Icebreaker", description = "Эндпоинты для работы с темами для общения (Icebreakers): получение случайных тем, добавление новых, редактирование")
public class IcebreakerController {
    
}
