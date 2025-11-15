package com.efedotov.meet_now.meet_now.controller.content;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.icebreaker.IcebreakerCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.icebreaker.IcebreakerUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.content.IcebreakerStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.content.IcebreakerTopec;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.content.IcebreakerService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/icebreaker")
@Tag(name = "Icebreaker", description = "Эндпоинты для работы с темами для общения (Icebreakers): получение случайных тем, добавление новых, редактирование")
@RequiredArgsConstructor
public class IcebreakerController {

    private final IcebreakerService icebreakerService;

    @Operation(summary = "Получить все темы с пагинацией (только для администратора)")
    @GetMapping("/admin/all")
    @AdminOnly
    public ResponseEntity<Page<IcebreakerTopec>> getAllTopicsWithPagination(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String search) {
        Page<IcebreakerTopec> topics = icebreakerService.getAllTopicsWithPagination(page, size, search);
        return ResponseEntity.ok(topics);
    }

    @Operation(summary = "Получить статистику по темам (только для администратора)")
    @GetMapping("/admin/statistics")
    @AdminOnly
    public ResponseEntity<IcebreakerStatisticsResponse> getIcebreakerStatistics() {
        IcebreakerStatisticsResponse statistics = icebreakerService.getIcebreakerStatistics();
        return ResponseEntity.ok(statistics);
    }

    @Operation(summary = "Получить тему по ID (только для администратора)")
    @GetMapping("/admin/{id}")
    @AdminOnly
    public ResponseEntity<IcebreakerTopec> getTopicById(@PathVariable Long id) {
        IcebreakerTopec topic = icebreakerService.getTopicById(id);
        return ResponseEntity.ok(topic);
    }

    @Operation(summary = "Создать новую тему (только для администратора)")
    @PostMapping("/admin")
    @AdminOnly
    public ResponseEntity<IcebreakerTopec> createTopic(@RequestBody IcebreakerCreateRequest request) {
        IcebreakerTopec createdTopic = icebreakerService.createTopic(request);
        return ResponseEntity.ok(createdTopic);
    }

    @Operation(summary = "Обновить тему (только для администратора)")
    @PutMapping("/admin/{id}")
    @AdminOnly
    public ResponseEntity<IcebreakerTopec> updateTopic(
            @PathVariable Long id,
            @RequestBody IcebreakerUpdateRequest request) {
        IcebreakerTopec updatedTopic = icebreakerService.updateTopic(id, request);
        return ResponseEntity.ok(updatedTopic);
    }

    @Operation(summary = "Удалить тему (только для администратора)")
    @DeleteMapping("/admin/{id}")
    @AdminOnly
    public ResponseEntity<Void> deleteTopic(@PathVariable Long id) {
        icebreakerService.deleteTopic(id);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Массовое удаление тем (только для администратора)")
    @DeleteMapping("/admin/bulk")
    @AdminOnly
    public ResponseEntity<Void> bulkDeleteTopics(@RequestBody List<Long> topicIds) {
        icebreakerService.bulkDeleteTopics(topicIds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Экспорт всех тем (только для администратора)")
    @GetMapping("/admin/export")
    @AdminOnly
    public ResponseEntity<List<IcebreakerTopec>> exportAllTopics() {
        List<IcebreakerTopec> topics = icebreakerService.exportAllTopics();
        return ResponseEntity.ok(topics);
    }

    @Operation(summary = "Поиск тем с пагинацией (только для администратора)")
    @GetMapping("/admin/search")
    @AdminOnly
    public ResponseEntity<Page<IcebreakerTopec>> searchTopicsWithPagination(
            @RequestParam String text,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        Page<IcebreakerTopec> topics = icebreakerService.searchTopicsWithPagination(text, page, size);
        return ResponseEntity.ok(topics);
    }

    @GetMapping("/random")
    @Operation(summary = "Получить случайную тему для общения")
    public ResponseEntity<IcebreakerTopec> getRandomTopic() {
        IcebreakerTopec topic = icebreakerService.getRandomTopic();
        return ResponseEntity.ok(topic);
    }

    @GetMapping("/get_all_ice")
    @Operation(summary = "Получить все темы для общения")
    public ResponseEntity<List<IcebreakerTopec>> getAllTopics() {
        List<IcebreakerTopec> topics = icebreakerService.getAllTopics();
        return ResponseEntity.ok(topics);
    }

    @PostMapping("/add_new_ice")
    @Operation(summary = "Добавить новую тему для общения")
    public ResponseEntity<IcebreakerTopec> addTopic(@RequestBody IcebreakerTopec topicRequest) {
        IcebreakerTopec createdTopic = icebreakerService.addTopic(topicRequest.getText());
        return ResponseEntity.ok(createdTopic);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Редактировать существующую тему по ID")
    public ResponseEntity<IcebreakerTopec> updateTopic(@PathVariable Long id,
            @RequestBody IcebreakerTopec topicRequest) {
        IcebreakerTopec updatedTopic = icebreakerService.updateTopic(id, topicRequest.getText());
        return ResponseEntity.ok(updatedTopic);
    }

    @GetMapping("/search")
    @Operation(summary = "Поиск тем по тексту")
    public ResponseEntity<List<IcebreakerTopec>> searchTopics(@RequestParam("text") String text) {
        List<IcebreakerTopec> topics = icebreakerService.findTopicsByText(text);
        return ResponseEntity.ok(topics);
    }
}