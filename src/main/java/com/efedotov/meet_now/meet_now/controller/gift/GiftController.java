package com.efedotov.meet_now.meet_now.controller.gift;

import com.efedotov.meet_now.meet_now.dto.request.gift.SendGiftRequest;
import com.efedotov.meet_now.meet_now.dto.response.gift.*;
import com.efedotov.meet_now.meet_now.service.gift.GiftService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/gifts")
@RequiredArgsConstructor
@Tag(name = "Gifts", description = "API для работы с подарками")
public class GiftController {

    private final GiftService giftService;

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
            @AuthenticationPrincipal UUID userId,
            @RequestBody SendGiftRequest request) {
        SentGiftDto sentGift = giftService.sendGift(userId, request);
        return ResponseEntity.ok(sentGift);
    }

    @GetMapping("/sent")
    @Operation(summary = "Получить отправленные подарки")
    public ResponseEntity<List<SentGiftDto>> getSentGifts(
            @AuthenticationPrincipal UUID userId,
            @RequestParam(defaultValue = "20") int limit) {
        List<SentGiftDto> sentGifts = giftService.getSentGifts(userId, limit);
        return ResponseEntity.ok(sentGifts);
    }

    @GetMapping("/received")
    @Operation(summary = "Получить полученные подарки")
    public ResponseEntity<List<SentGiftDto>> getReceivedGifts(
            @AuthenticationPrincipal UUID userId,
            @RequestParam(defaultValue = "20") int limit) {
        List<SentGiftDto> receivedGifts = giftService.getReceivedGifts(userId, limit);
        return ResponseEntity.ok(receivedGifts);
    }

    @GetMapping("/inventory")
    @Operation(summary = "Получить инвентарь пользователя")
    public ResponseEntity<List<UserInventoryDto>> getInventory(@AuthenticationPrincipal UUID userId) {
        List<UserInventoryDto> inventory = giftService.getUserInventory(userId);
        return ResponseEntity.ok(inventory);
    }

    @PostMapping("/daily")
    @Operation(summary = "Получить ежедневный подарок")
    public ResponseEntity<GiftDto> claimDailyGift(@AuthenticationPrincipal UUID userId) {
        GiftDto dailyGift = giftService.claimDailyGift(userId);
        return ResponseEntity.ok(dailyGift);
    }

    @GetMapping("/daily/available")
    @Operation(summary = "Проверить доступность ежедневного подарка")
    public ResponseEntity<Boolean> isDailyGiftAvailable(@AuthenticationPrincipal UUID userId) {
        boolean isAvailable = giftService.isDailyGiftAvailable(userId);
        return ResponseEntity.ok(isAvailable);
    }

    @GetMapping("/daily/streak")
    @Operation(summary = "Получить текущую серию ежедневных подарков")
    public ResponseEntity<Integer> getCurrentStreak(@AuthenticationPrincipal UUID userId) {
        Integer streak = giftService.getCurrentStreak(userId);
        return ResponseEntity.ok(streak);
    }

    @GetMapping("/stats")
    @Operation(summary = "Получить статистику по подаркам")
    public ResponseEntity<GiftStatsDto> getGiftStats(@AuthenticationPrincipal UUID userId) {
        GiftStatsDto stats = giftService.getGiftStats(userId);
        return ResponseEntity.ok(stats);
    }
}