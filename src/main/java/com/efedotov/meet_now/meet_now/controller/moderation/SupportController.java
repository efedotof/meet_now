package com.efedotov.meet_now.meet_now.controller.moderation;

import com.efedotov.meet_now.meet_now.dto.request.moderation.CreateAnswerRequest;
import com.efedotov.meet_now.meet_now.dto.request.moderation.CreateQuestionRequest;
import com.efedotov.meet_now.meet_now.dto.response.moderation.AnswerDTO;
import com.efedotov.meet_now.meet_now.dto.response.moderation.QuestionDTO;
import com.efedotov.meet_now.meet_now.model.moderation.Answer;
import com.efedotov.meet_now.meet_now.model.moderation.Question;
import com.efedotov.meet_now.meet_now.model.moderation.QuestionStatus;
import com.efedotov.meet_now.meet_now.service.moderation.SupportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/support")
@Validated
@RequiredArgsConstructor
@Tag(name = "Support", description = "API для системы поддержки пользователей")
@SecurityRequirement(name = "bearerAuth")
public class SupportController {
    private final SupportService supportService;

    @Operation(summary = "Создать новый вопрос", description = "Позволяет пользователю создать вопрос в службу поддержки")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Вопрос успешно создан"),
            @ApiResponse(responseCode = "400", description = "Неверные входные данные")
    })
    @PostMapping("/questions")
    public ResponseEntity<QuestionDTO> createQuestion(
            @Valid @RequestBody CreateQuestionRequest request,
            @AuthenticationPrincipal UUID userId) {
        Question question = supportService.createQuestion(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDTO(question));
    }

    @Operation(summary = "Добавить ответ на вопрос", description = "Позволяет модераторам и администраторам добавлять ответы на вопросы")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Ответ успешно добавлен"),
            @ApiResponse(responseCode = "403", description = "Недостаточно прав"),
            @ApiResponse(responseCode = "404", description = "Вопрос не найден")
    })
    @PostMapping("/questions/{questionId}/answers")
    public ResponseEntity<AnswerDTO> addAnswer(
            @Parameter(description = "ID вопроса") @PathVariable UUID questionId,
            @Valid @RequestBody CreateAnswerRequest request,
            @AuthenticationPrincipal UUID userId) {
        Answer answer = supportService.addAnswerToQuestion(questionId, request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDTO(answer));
    }

    @Operation(summary = "Получить все вопросы", description = "Возвращает список всех вопросов (только для модераторов и администраторов)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Список вопросов получен"),
            @ApiResponse(responseCode = "403", description = "Недостаточно прав")
    })
    @GetMapping("/questions")
    public ResponseEntity<List<QuestionDTO>> getAllQuestions(@AuthenticationPrincipal UUID userId) {
        List<Question> questions = supportService.getAllQuestions();
        return ResponseEntity.ok(questions.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList()));
    }

    @Operation(summary = "Получить вопросы пользователя", description = "Возвращает список вопросов текущего пользователя")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Список вопросов получен")
    })
    @GetMapping("/questions/my")
    public ResponseEntity<List<QuestionDTO>> getMyQuestions(@AuthenticationPrincipal UUID userId) {
        List<Question> questions = supportService.getUserQuestions(userId);
        return ResponseEntity.ok(questions.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList()));
    }

    @Operation(summary = "Получить вопрос по ID", description = "Возвращает вопрос по его идентификатору")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Вопрос найден"),
            @ApiResponse(responseCode = "404", description = "Вопрос не найден")
    })
    @GetMapping("/questions/{id}")
    public ResponseEntity<QuestionDTO> getQuestion(
            @Parameter(description = "ID вопроса") @PathVariable UUID id) {
        Question question = supportService.getQuestionById(id);
        return ResponseEntity.ok(mapToDTO(question));
    }

    @Operation(summary = "Обновить статус вопроса", description = "Позволяет модераторам и администраторам обновлять статус вопроса")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Статус обновлен"),
            @ApiResponse(responseCode = "403", description = "Недостаточно прав"),
            @ApiResponse(responseCode = "404", description = "Вопрос не найден")
    })
    @PatchMapping("/questions/{id}/status")
    public ResponseEntity<QuestionDTO> updateStatus(
            @Parameter(description = "ID вопроса") @PathVariable UUID id,
            @Parameter(description = "Новый статус") @RequestParam QuestionStatus status,
            @AuthenticationPrincipal UUID userId) {
        Question question = supportService.updateQuestionStatus(id, status, userId);
        return ResponseEntity.ok(mapToDTO(question));
    }

    private QuestionDTO mapToDTO(Question question) {
        QuestionDTO dto = new QuestionDTO();
        dto.setId(question.getId());
        dto.setTitle(question.getTitle());
        dto.setDescription(question.getDescription());
        dto.setStatus(question.getStatus());
        dto.setUserId(question.getUserId());
        dto.setCreatedAt(question.getCreatedAt());
        dto.setUpdatedAt(question.getUpdatedAt());
        if (question.getAnswers() != null) {
            dto.setAnswers(question.getAnswers().stream()
                    .map(this::mapToDTO)
                    .collect(Collectors.toList()));
        }
        return dto;
    }

    private AnswerDTO mapToDTO(Answer answer) {
        AnswerDTO dto = new AnswerDTO();
        dto.setId(answer.getId());
        dto.setContent(answer.getContent());
        dto.setCreatedBy(answer.getCreatedBy());
        dto.setCreatedAt(answer.getCreatedAt());
        return dto;
    }
}