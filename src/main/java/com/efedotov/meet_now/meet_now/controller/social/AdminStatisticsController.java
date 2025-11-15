package com.efedotov.meet_now.meet_now.controller.social;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.dto.response.statistics.AdminSystemStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.RealtimeStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.UserGrowthStatisticsDto;
import com.efedotov.meet_now.meet_now.service.social.StatisticsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/admin/statistics")
@Tag(name = "Admin Statistics", description = "[АДМИНИСТРАТОР] API для получения статистики системы")
@RequiredArgsConstructor
public class AdminStatisticsController {

    private final StatisticsService statisticsService;

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить полную статистику системы", description = "Возвращает комплексную статистику по всем аспектам системы")
    @GetMapping("/system")
    public ResponseEntity<AdminSystemStatisticsDto> getSystemStatistics() {
        AdminSystemStatisticsDto statistics = statisticsService.getAdminSystemStatistics();
        return ResponseEntity.ok(statistics);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить статистику в реальном времени", description = "Возвращает ключевые метрики системы в реальном времени")
    @GetMapping("/realtime")
    public ResponseEntity<RealtimeStatisticsDto> getRealtimeStatistics() {
        RealtimeStatisticsDto statistics = statisticsService.getRealtimeStatistics();
        return ResponseEntity.ok(statistics);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить статистику роста пользователей", description = "Возвращает статистику роста пользователей за указанный период")
    @GetMapping("/user-growth")
    public ResponseEntity<UserGrowthStatisticsDto> getUserGrowthStatistics(
            @RequestParam(defaultValue = "30") int days) {
        UserGrowthStatisticsDto statistics = statisticsService.getUserGrowthStatistics(days);
        return ResponseEntity.ok(statistics);
    }
}