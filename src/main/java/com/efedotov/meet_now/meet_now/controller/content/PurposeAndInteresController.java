package com.efedotov.meet_now.meet_now.controller.content;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.efedotov.meet_now.meet_now.dto.request.content.InterestCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.InterestUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.PurposeCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.PurposeUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.content.PurposeInterestStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.user.Interest;
import com.efedotov.meet_now.meet_now.model.user.Purpose;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.content.PurposeAndInterestService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/purpAndInt")
@Tag(name = "Интересы и Цели", description = "Эндпоинты для работы с интересами и целями")
@RequiredArgsConstructor
public class PurposeAndInteresController {

    private final PurposeAndInterestService purpAndIntService;

    @Operation(summary = "Получить все интересы с пагинацией (только для администратора)")
    @GetMapping("/admin/interests")
    @AdminOnly
    public ResponseEntity<Page<Interest>> getAllInterestsAdmin(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String search) {
        Page<Interest> interests = purpAndIntService.getAllInterestsWithPagination(page, size, search);
        return ResponseEntity.ok(interests);
    }

    @Operation(summary = "Создать новый интерес (только для администратора)")
    @PostMapping("/admin/interests")
    @AdminOnly
    public ResponseEntity<Interest> createInterest(@RequestBody InterestCreateRequest request) {
        Interest interest = purpAndIntService.createInterest(request);
        return ResponseEntity.ok(interest);
    }

    @Operation(summary = "Обновить интерес (только для администратора)")
    @PutMapping("/admin/interests/{interestId}")
    @AdminOnly
    public ResponseEntity<Interest> updateInterest(
            @PathVariable UUID interestId,
            @RequestBody InterestUpdateRequest request) {
        Interest interest = purpAndIntService.updateInterest(interestId, request);
        return ResponseEntity.ok(interest);
    }

    @Operation(summary = "Удалить интерес (только для администратора)")
    @DeleteMapping("/admin/interests/{interestId}")
    @AdminOnly
    public ResponseEntity<Void> deleteInterest(@PathVariable UUID interestId) {
        purpAndIntService.deleteInterest(interestId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить интерес по ID (только для администратора)")
    @GetMapping("/admin/interests/{interestId}")
    @AdminOnly
    public ResponseEntity<Interest> getInterestById(@PathVariable UUID interestId) {
        Interest interest = purpAndIntService.getInterestById(interestId);
        return ResponseEntity.ok(interest);
    }

    @Operation(summary = "Получить все цели с пагинацией (только для администратора)")
    @GetMapping("/admin/purposes")
    @AdminOnly
    public ResponseEntity<Page<Purpose>> getAllPurposesAdmin(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String search) {
        Page<Purpose> purposes = purpAndIntService.getAllPurposesWithPagination(page, size, search);
        return ResponseEntity.ok(purposes);
    }

    @Operation(summary = "Создать новую цель (только для администратора)")
    @PostMapping("/admin/purposes")
    @AdminOnly
    public ResponseEntity<Purpose> createPurpose(@RequestBody PurposeCreateRequest request) {
        Purpose purpose = purpAndIntService.createPurpose(request);
        return ResponseEntity.ok(purpose);
    }

    @Operation(summary = "Обновить цель (только для администратора)")
    @PutMapping("/admin/purposes/{purposeId}")
    @AdminOnly
    public ResponseEntity<Purpose> updatePurpose(
            @PathVariable UUID purposeId,
            @RequestBody PurposeUpdateRequest request) {
        Purpose purpose = purpAndIntService.updatePurpose(purposeId, request);
        return ResponseEntity.ok(purpose);
    }

    @Operation(summary = "Удалить цель (только для администратора)")
    @DeleteMapping("/admin/purposes/{purposeId}")
    @AdminOnly
    public ResponseEntity<Void> deletePurpose(@PathVariable UUID purposeId) {
        purpAndIntService.deletePurpose(purposeId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить цель по ID (только для администратора)")
    @GetMapping("/admin/purposes/{purposeId}")
    @AdminOnly
    public ResponseEntity<Purpose> getPurposeById(@PathVariable UUID purposeId) {
        Purpose purpose = purpAndIntService.getPurposeById(purposeId);
        return ResponseEntity.ok(purpose);
    }

    @Operation(summary = "Получить статистику по интересам и целям (только для администратора)")
    @GetMapping("/admin/statistics")
    @AdminOnly
    public ResponseEntity<PurposeInterestStatisticsResponse> getStatistics() {
        PurposeInterestStatisticsResponse statistics = purpAndIntService.getPurposeInterestStatistics();
        return ResponseEntity.ok(statistics);
    }

    @Operation(summary = "Массовое удаление интересов (только для администратора)")
    @DeleteMapping("/admin/interests/bulk")
    @AdminOnly
    public ResponseEntity<Void> bulkDeleteInterests(@RequestBody List<UUID> interestIds) {
        purpAndIntService.bulkDeleteInterests(interestIds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Массовое удаление целей (только для администратора)")
    @DeleteMapping("/admin/purposes/bulk")
    @AdminOnly
    public ResponseEntity<Void> bulkDeletePurposes(@RequestBody List<UUID> purposeIds) {
        purpAndIntService.bulkDeletePurposes(purposeIds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Экспорт всех интересов (только для администратора)")
    @GetMapping("/admin/interests/export")
    @AdminOnly
    public ResponseEntity<List<Interest>> exportAllInterests() {
        List<Interest> interests = purpAndIntService.exportAllInterests();
        return ResponseEntity.ok(interests);
    }

    @Operation(summary = "Экспорт всех целей (только для администратора)")
    @GetMapping("/admin/purposes/export")
    @AdminOnly
    public ResponseEntity<List<Purpose>> exportAllPurposes() {
        List<Purpose> purposes = purpAndIntService.exportAllPurposes();
        return ResponseEntity.ok(purposes);
    }

    @GetMapping("/getInterest")
    @Operation(summary = "Получить все интересы")
    public ResponseEntity<?> getInterest() {
        try {
            return ResponseEntity.ok(purpAndIntService.getAllInterest());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Что-то пошло не так: " + e.getMessage());
        }
    }

    @GetMapping("/getPurpose")
    @Operation(summary = "Получить все цели")
    public ResponseEntity<?> getPurpose() {
        try {
            return ResponseEntity.ok(purpAndIntService.getAllPurpose());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Что-то пошло не так: " + e.getMessage());
        }
    }
}