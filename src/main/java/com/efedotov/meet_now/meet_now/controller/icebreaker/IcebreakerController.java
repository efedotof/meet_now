package com.efedotov.meet_now.meet_now.controller.icebreaker;

import com.efedotov.meet_now.meet_now.model.IcebreakerTopec;
import com.efedotov.meet_now.meet_now.service.IcebreakerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/icebreaker")
@Tag(name = "Icebreaker", description = "Эндпоинты для работы с темами для общения (Icebreakers): получение случайных тем, добавление новых, редактирование")
@RequiredArgsConstructor
@EnableMethodSecurity
public class IcebreakerController {

    private final IcebreakerService icebreakerService;

    @GetMapping("/random")
    @Operation(summary = "Получить случайную тему для общения")
    public ResponseEntity<IcebreakerTopec> getRandomTopic() {
        IcebreakerTopec topic = icebreakerService.getRandomTopic();
        return ResponseEntity.ok(topic);
    }

    @GetMapping
    @Operation(summary = "Получить все темы для общения")
    public ResponseEntity<List<IcebreakerTopec>> getAllTopics() {
        List<IcebreakerTopec> topics = icebreakerService.getAllTopics();
        return ResponseEntity.ok(topics);
    }

    @PostMapping
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
