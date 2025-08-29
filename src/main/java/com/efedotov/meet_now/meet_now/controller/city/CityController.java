package com.efedotov.meet_now.meet_now.controller.city;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.service.CityService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/cities")
@RequiredArgsConstructor
@Tag(name = "City Controller", description = "API для работы с городами")
public class CityController {
    
    private final CityService cityService;

    @GetMapping("/search")
    @Operation(
        summary = "Поиск городов по названию",
        description = "Возвращает список городов, содержащих указанную строку в названии",
        responses = {
            @ApiResponse(responseCode = "200", description = "Успешный поиск"),
            @ApiResponse(responseCode = "400", description = "Неверные параметры запроса")
        }
    )
    public ResponseEntity<List<String>> searchCities(
            @Parameter(description = "Строка для поиска", example = "Мо", required = true)
            @RequestParam String query,
            
            @Parameter(description = "Ограничение количества результатов (по умолчанию 10)", example = "5")
            @RequestParam(required = false, defaultValue = "10") int limit) {
        
        if (query == null || query.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(List.of());
        }
        
        List<String> cities = cityService.searchCitiesLimited(query.trim(), limit);
        return ResponseEntity.ok(cities);
    }

    @GetMapping("/search/prefix")
    @Operation(
        summary = "Поиск городов по префиксу",
        description = "Возвращает список городов, начинающихся с указанной строки",
        responses = {
            @ApiResponse(responseCode = "200", description = "Успешный поиск"),
            @ApiResponse(responseCode = "400", description = "Неверные параметры запроса")
        }
    )
    public ResponseEntity<List<String>> searchCitiesByPrefix(
            @Parameter(description = "Префикс для поиска", example = "Мо", required = true)
            @RequestParam String prefix,
            
            @Parameter(description = "Ограничение количества результатов", example = "5")
            @RequestParam(required = false, defaultValue = "10") int limit) {
        
        if (prefix == null || prefix.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(List.of());
        }
        
        List<String> cities = cityService.searchCitiesByPrefixLimited(prefix.trim(), limit);
        return ResponseEntity.ok(cities);
    }
}