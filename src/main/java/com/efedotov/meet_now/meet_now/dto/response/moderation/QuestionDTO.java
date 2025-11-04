package com.efedotov.meet_now.meet_now.dto.response.moderation;

import com.efedotov.meet_now.meet_now.model.moderation.QuestionStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Schema(description = "DTO вопроса поддержки")
public class QuestionDTO {
    @Schema(description = "ID вопроса")
    private UUID id;

    @Schema(description = "Заголовок вопроса")
    private String title;

    @Schema(description = "Описание вопроса")
    private String description;

    @Schema(description = "Статус вопроса")
    private QuestionStatus status;

    @Schema(description = "ID пользователя, создавшего вопрос")
    private UUID userId;

    @Schema(description = "Дата создания")
    private LocalDateTime createdAt;

    @Schema(description = "Дата обновления")
    private LocalDateTime updatedAt;

    @Schema(description = "Список ответов")
    private List<AnswerDTO> answers;
}