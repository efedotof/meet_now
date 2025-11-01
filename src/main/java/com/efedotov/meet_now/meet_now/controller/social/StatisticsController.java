package com.efedotov.meet_now.meet_now.controller.social;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.response.social.UserStatsDto;
import com.efedotov.meet_now.meet_now.service.social.StatisticsService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/stats")
@Tag(name = "Statistics", description = "Статистика пользователей")
@RequiredArgsConstructor
public class StatisticsController {

    private final StatisticsService statisticsService;

    @Operation(summary = "Получить текущую статистику пользователей")
    @GetMapping
    public ResponseEntity<UserStatsDto> getCurrentStats() {
        return ResponseEntity.ok(statisticsService.getUserStats());
    }
}
