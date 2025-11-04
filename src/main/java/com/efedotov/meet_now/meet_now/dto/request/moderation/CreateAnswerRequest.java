package com.efedotov.meet_now.meet_now.dto.request.moderation;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Schema(description = "Запрос на создание ответа на вопрос")
public class CreateAnswerRequest {
    @NotBlank(message = "Content is required")
    @Schema(description = "Содержание ответа", example = "Попробуйте сбросить пароль через функцию восстановления")
    private String content;
}