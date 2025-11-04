package com.efedotov.meet_now.meet_now.dto.request.moderation;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Schema(description = "Запрос на создание вопроса в поддержку")
public class CreateQuestionRequest {
    @NotBlank(message = "Title is required")
    @Schema(description = "Заголовок вопроса", example = "Проблема с входом в систему")
    private String title;
    
    @NotBlank(message = "Description is required")
    @Schema(description = "Описание проблемы", example = "Не могу войти в аккаунт с правильными данными")
    private String description;
}