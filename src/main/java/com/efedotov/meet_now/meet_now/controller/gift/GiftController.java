package com.efedotov.meet_now.meet_now.controller.gift;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.request.gift.AdminCreateGiftRarityRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminCreateGiftRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminUpdateGiftRarityRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminUpdateGiftRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.SendGiftRequest;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminGiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminGiftRarityDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminGiftStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminSentGiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminUserGiftStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminUserInventoryDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftRarityDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.SentGiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.UserInventoryDto;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.gift.GiftService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/gifts")
@RequiredArgsConstructor
@Tag(name = "Gifts", description = "API для работы с подарками")
public class GiftController {

    private final GiftService giftService;

    @GetMapping("/admin/all")
    @Operation(summary = "[ADMIN] Получить все подарки (включая неактивные)")
    @AdminOnly
    public ResponseEntity<List<AdminGiftDto>> getAllGiftsAdmin() {
        List<AdminGiftDto> gifts = giftService.getAllGiftsAdmin();
        return ResponseEntity.ok(gifts);
    }

    @PostMapping("/admin/create")
    @Operation(summary = "[ADMIN] Создать новый подарок")
    @AdminOnly
    public ResponseEntity<AdminGiftDto> createGift(@RequestBody AdminCreateGiftRequest request) {
        AdminGiftDto gift = giftService.createGift(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(gift);
    }

    @PutMapping("/admin/{giftId}")
    @Operation(summary = "[ADMIN] Обновить подарок")
    @AdminOnly
    public ResponseEntity<AdminGiftDto> updateGift(
            @PathVariable UUID giftId,
            @RequestBody AdminUpdateGiftRequest request) {
        AdminGiftDto gift = giftService.updateGift(giftId, request);
        return ResponseEntity.ok(gift);
    }

    @DeleteMapping("/admin/{giftId}")
    @Operation(summary = "[ADMIN] Удалить подарок")
    @AdminOnly
    public ResponseEntity<Void> deleteGift(@PathVariable UUID giftId) {
        giftService.deleteGift(giftId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/admin/{giftId}/toggle")
    @Operation(summary = "[ADMIN] Переключить активность подарка")
    @AdminOnly
    public ResponseEntity<AdminGiftDto> toggleGiftActive(@PathVariable UUID giftId) {
        AdminGiftDto gift = giftService.toggleGiftActive(giftId);
        return ResponseEntity.ok(gift);
    }

    @GetMapping("/admin/rarities/all")
    @Operation(summary = "[ADMIN] Получить все редкости (включая неактивные)")
    @AdminOnly
    public ResponseEntity<List<AdminGiftRarityDto>> getAllRaritiesAdmin() {
        List<AdminGiftRarityDto> rarities = giftService.getAllRaritiesAdmin();
        return ResponseEntity.ok(rarities);
    }

    @PostMapping("/admin/rarities/create")
    @Operation(summary = "[ADMIN] Создать новую редкость")
    @AdminOnly
    public ResponseEntity<AdminGiftRarityDto> createGiftRarity(@RequestBody AdminCreateGiftRarityRequest request) {
        AdminGiftRarityDto rarity = giftService.createGiftRarity(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(rarity);
    }

    @PutMapping("/admin/rarities/{rarityId}")
    @Operation(summary = "[ADMIN] Обновить редкость")
    @AdminOnly
    public ResponseEntity<AdminGiftRarityDto> updateGiftRarity(
            @PathVariable UUID rarityId,
            @RequestBody AdminUpdateGiftRarityRequest request) {
        AdminGiftRarityDto rarity = giftService.updateGiftRarity(rarityId, request);
        return ResponseEntity.ok(rarity);
    }

    @DeleteMapping("/admin/rarities/{rarityId}")
    @Operation(summary = "[ADMIN] Удалить редкость")
    @AdminOnly
    public ResponseEntity<Void> deleteGiftRarity(@PathVariable UUID rarityId) {
        giftService.deleteGiftRarity(rarityId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/admin/stats")
    @Operation(summary = "[ADMIN] Получить общую статистику по подаркам")
    @AdminOnly
    public ResponseEntity<AdminGiftStatsDto> getAdminGiftStats() {
        AdminGiftStatsDto stats = giftService.getAdminGiftStats();
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/admin/sent/history")
    @Operation(summary = "[ADMIN] Получить историю отправленных подарков")
    @AdminOnly
    public ResponseEntity<List<AdminSentGiftDto>> getSentGiftsAdmin(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        List<AdminSentGiftDto> sentGifts = giftService.getSentGiftsAdmin(page, size);
        return ResponseEntity.ok(sentGifts);
    }

    @GetMapping("/admin/user/{userId}/inventory")
    @Operation(summary = "[ADMIN] Получить инвентарь пользователя")
    @AdminOnly
    public ResponseEntity<List<AdminUserInventoryDto>> getUserInventoryAdmin(@PathVariable UUID userId) {
        List<AdminUserInventoryDto> inventory = giftService.getUserInventoryAdmin(userId);
        return ResponseEntity.ok(inventory);
    }

    @GetMapping("/admin/user/{userId}/stats")
    @Operation(summary = "[ADMIN] Получить статистику по подаркам пользователя")
    @AdminOnly
    public ResponseEntity<AdminUserGiftStatsDto> getUserGiftStatsAdmin(@PathVariable UUID userId) {
        AdminUserGiftStatsDto stats = giftService.getUserGiftStatsAdmin(userId);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/available")
    @Operation(summary = "Получить все доступные подарки")
    public ResponseEntity<List<GiftDto>> getAvailableGifts() {
        List<GiftDto> gifts = giftService.getAllAvailableGifts();
        return ResponseEntity.ok(gifts);
    }

    @GetMapping("/type/{typeName}")
    @Operation(summary = "Получить подарки по типу")
    public ResponseEntity<List<GiftDto>> getGiftsByType(@PathVariable String typeName) {
        List<GiftDto> gifts = giftService.getGiftsByType(typeName);
        return ResponseEntity.ok(gifts);
    }

    @GetMapping("/rarity/{rarityName}")
    @Operation(summary = "Получить подарки по редкости")
    public ResponseEntity<List<GiftDto>> getGiftsByRarity(@PathVariable String rarityName) {
        List<GiftDto> gifts = giftService.getGiftsByRarity(rarityName);
        return ResponseEntity.ok(gifts);
    }

    @GetMapping("/rarities")
    @Operation(summary = "Получить все редкости подарков")
    public ResponseEntity<List<GiftRarityDto>> getAllRarities() {
        List<GiftRarityDto> rarities = giftService.getAllRarities();
        return ResponseEntity.ok(rarities);
    }

    @GetMapping("/rarity/{name}/info")
    @Operation(summary = "Получить информацию о редкости по имени")
    public ResponseEntity<GiftRarityDto> getRarityByName(@PathVariable String name) {
        GiftRarityDto rarity = giftService.getRarityByName(name);
        return ResponseEntity.ok(rarity);
    }

    @GetMapping("/cost-range")
    @Operation(summary = "Получить подарки по диапазону стоимости")
    public ResponseEntity<List<GiftDto>> getGiftsByCostRange(
            @RequestParam(required = false) Integer minCost,
            @RequestParam(required = false) Integer maxCost) {
        List<GiftDto> gifts = giftService.getGiftsByCostRange(minCost, maxCost);
        return ResponseEntity.ok(gifts);
    }

    @PostMapping("/send")
    @Operation(summary = "Отправить подарок")
    public ResponseEntity<SentGiftDto> sendGift(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody SendGiftRequest request) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        SentGiftDto sentGift = giftService.sendGift(userId, request);
        return ResponseEntity.ok(sentGift);
    }

    @GetMapping("/sent")
    @Operation(summary = "Получить отправленные подарки")
    public ResponseEntity<List<SentGiftDto>> getSentGifts(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(defaultValue = "20") int limit) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        List<SentGiftDto> sentGifts = giftService.getSentGifts(userId, limit);
        return ResponseEntity.ok(sentGifts);
    }

    @GetMapping("/received")
    @Operation(summary = "Получить полученные подарки")
    public ResponseEntity<List<SentGiftDto>> getReceivedGifts(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(defaultValue = "20") int limit) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        List<SentGiftDto> receivedGifts = giftService.getReceivedGifts(userId, limit);
        return ResponseEntity.ok(receivedGifts);
    }

    @GetMapping("/inventory")
    @Operation(summary = "Получить инвентарь пользователя")
    public ResponseEntity<List<UserInventoryDto>> getInventory(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        List<UserInventoryDto> inventory = giftService.getUserInventory(userId);
        return ResponseEntity.ok(inventory);
    }

    @PostMapping("/daily")
    @Operation(summary = "Получить ежедневный подарок")
    public ResponseEntity<?> claimDailyGift(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        try {
            UUID userId = userDetails.getUserId();
            GiftDto dailyGift = giftService.claimDailyGift(userId);
            return ResponseEntity.ok(dailyGift);
        } catch (ResponseStatusException e) {
            throw e;
        } catch (Exception e) {
            log.error("Неожиданная ошибка при получении ежедневного подарка: {}", e.getMessage());
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                    "Произошла непредвиденная ошибка при получении подарка");
        }
    }

    @GetMapping("/daily/available")
    @Operation(summary = "Проверить доступность ежедневного подарка")
    public ResponseEntity<Boolean> isDailyGiftAvailable(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        boolean isAvailable = giftService.isDailyGiftAvailable(userId);
        return ResponseEntity.ok(isAvailable);
    }

    @GetMapping("/daily/streak")
    @Operation(summary = "Получить текущую серию ежедневных подарков")
    public ResponseEntity<Integer> getCurrentStreak(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        Integer streak = giftService.getCurrentStreak(userId);
        return ResponseEntity.ok(streak);
    }

    @GetMapping("/stats")
    @Operation(summary = "Получить статистику по подаркам")
    public ResponseEntity<GiftStatsDto> getGiftStats(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        GiftStatsDto stats = giftService.getGiftStats(userId);
        return ResponseEntity.ok(stats);
    }
}