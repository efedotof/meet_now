package com.efedotov.meet_now.meet_now.controller.content;

import java.util.List;
import java.util.UUID;

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

import com.efedotov.meet_now.meet_now.dto.request.city.CityCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.city.CityUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.city.CityStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.user.City;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.content.CityService;

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

    @Operation(summary = "Получить все города с пагинацией (только для администратора)")
    @GetMapping("/admin/all")
    @AdminOnly
    public ResponseEntity<Page<City>> getAllCities(
            @Parameter(description = "Номер страницы (по умолчанию 0)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Размер страницы (по умолчанию 20)") @RequestParam(defaultValue = "20") int size,
            @Parameter(description = "Поиск по названию города") @RequestParam(required = false) String search) {

        Page<City> cities = cityService.getAllCities(page, size, search);
        return ResponseEntity.ok(cities);
    }

    @Operation(summary = "Получить статистику по городам (только для администратора)")
    @GetMapping("/admin/statistics")
    @AdminOnly
    public ResponseEntity<CityStatisticsResponse> getCityStatistics() {
        CityStatisticsResponse statistics = cityService.getCityStatistics();
        return ResponseEntity.ok(statistics);
    }

    @Operation(summary = "Создать новый город (только для администратора)")
    @PostMapping("/admin")
    @AdminOnly
    public ResponseEntity<City> createCity(@RequestBody CityCreateRequest request) {
        City city = cityService.createCity(request);
        return ResponseEntity.ok(city);
    }

    @Operation(summary = "Обновить город (только для администратора)")
    @PutMapping("/admin/{cityId}")
    @AdminOnly
    public ResponseEntity<City> updateCity(
            @PathVariable UUID cityId,
            @RequestBody CityUpdateRequest request) {
        City city = cityService.updateCity(cityId, request);
        return ResponseEntity.ok(city);
    }

    @Operation(summary = "Удалить город (только для администратора)")
    @DeleteMapping("/admin/{cityId}")
    @AdminOnly
    public ResponseEntity<Void> deleteCity(@PathVariable UUID cityId) {
        cityService.deleteCity(cityId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Массовое удаление городов (только для администратора)")
    @DeleteMapping("/admin/bulk")
    @AdminOnly
    public ResponseEntity<Void> bulkDeleteCities(@RequestBody List<UUID> cityIds) {
        cityService.bulkDeleteCities(cityIds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить город по ID (только для администратора)")
    @GetMapping("/admin/{cityId}")
    @AdminOnly
    public ResponseEntity<City> getCityById(@PathVariable UUID cityId) {
        City city = cityService.getCityById(cityId);
        return ResponseEntity.ok(city);
    }

    @Operation(summary = "Экспорт данных городов (только для администратора)")
    @GetMapping("/admin/export")
    @AdminOnly
    public ResponseEntity<List<City>> exportCities() {
        List<City> cities = cityService.exportCities();
        return ResponseEntity.ok(cities);
    }

    @GetMapping("/search")
    @Operation(summary = "Поиск городов по названию", description = "Возвращает список городов, содержащих указанную строку в названии", responses = {
            @ApiResponse(responseCode = "200", description = "Успешный поиск"),
            @ApiResponse(responseCode = "400", description = "Неверные параметры запроса")
    })
    public ResponseEntity<List<City>> searchCities(
            @Parameter(description = "Строка для поиска", example = "Мо", required = true) @RequestParam String query,
            @Parameter(description = "Ограничение количества результатов (по умолчанию 10)", example = "5") @RequestParam(required = false, defaultValue = "10") int limit) {

        if (query == null || query.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(List.of());
        }

        List<City> cities = cityService.searchCitiesLimited(query.trim(), limit);
        return ResponseEntity.ok(cities);
    }

    @GetMapping("/search/prefix")
    @Operation(summary = "Поиск городов по префиксу", description = "Возвращает список городов, начинающихся с указанной строки", responses = {
            @ApiResponse(responseCode = "200", description = "Успешный поиск"),
            @ApiResponse(responseCode = "400", description = "Неверные параметры запроса")
    })
    public ResponseEntity<List<City>> searchCitiesByPrefix(
            @Parameter(description = "Префикс для поиска", example = "Мо", required = true) @RequestParam String prefix,
            @Parameter(description = "Ограничение количества результатов", example = "5") @RequestParam(required = false, defaultValue = "10") int limit) {

        if (prefix == null || prefix.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(List.of());
        }

        List<City> cities = cityService.searchCitiesByPrefixLimited(prefix.trim(), limit);
        return ResponseEntity.ok(cities);
    }
}