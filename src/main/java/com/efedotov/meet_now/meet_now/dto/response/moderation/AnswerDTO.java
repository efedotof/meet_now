package com.efedotov.meet_now.meet_now.dto.response.moderation;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Schema(description = "DTO ответа на вопрос")
public class AnswerDTO {
    @Schema(description = "ID ответа")
    private UUID id;

    @Schema(description = "Содержание ответа")
    private String content;

    @Schema(description = "ID пользователя, создавшего ответ")
    private UUID createdBy;

    @Schema(description = "Дата создания")
    private LocalDateTime createdAt;
}