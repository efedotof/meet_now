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

import com.efedotov.meet_now.meet_now.dto.request.content.StickerCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.StickerPackCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.StickerPackUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.StickerUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerPackDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerStatisticsResponse;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.content.StickersService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/stickers")
@Tag(name = "Stickers", description = "Управление стикерами и стикерпаками")
@RequiredArgsConstructor
public class StickersController {

    private final StickersService stickersService;

    @Operation(summary = "Получить все стикерпаки с пагинацией (только для администратора)")
    @GetMapping("/admin/packs")
    @AdminOnly
    public ResponseEntity<Page<StickerPackDto>> getAllStickerPacksAdmin(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        Page<StickerPackDto> packs = stickersService.getAllStickerPacksAdmin(page, size);
        return ResponseEntity.ok(packs);
    }

    @Operation(summary = "Создать новый стикерпак (только для администратора)")
    @PostMapping("/admin/packs")
    @AdminOnly
    public ResponseEntity<StickerPackDto> createStickerPack(@RequestBody StickerPackCreateRequest request) {
        StickerPackDto pack = stickersService.createStickerPack(request);
        return ResponseEntity.ok(pack);
    }

    @Operation(summary = "Обновить стикерпак (только для администратора)")
    @PutMapping("/admin/packs/{packId}")
    @AdminOnly
    public ResponseEntity<StickerPackDto> updateStickerPack(
            @PathVariable UUID packId,
            @RequestBody StickerPackUpdateRequest request) {
        StickerPackDto pack = stickersService.updateStickerPack(packId, request);
        return ResponseEntity.ok(pack);
    }

    @Operation(summary = "Удалить стикерпак (только для администратора)")
    @DeleteMapping("/admin/packs/{packId}")
    @AdminOnly
    public ResponseEntity<Void> deleteStickerPack(@PathVariable UUID packId) {
        stickersService.deleteStickerPack(packId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить стикерпак по ID (только для администратора)")
    @GetMapping("/admin/packs/{packId}")
    @AdminOnly
    public ResponseEntity<StickerPackDto> getStickerPackAdmin(@PathVariable UUID packId) {
        StickerPackDto pack = stickersService.getStickerPackAdmin(packId);
        return ResponseEntity.ok(pack);
    }

    @Operation(summary = "Получить все стикеры с пагинацией (только для администратора)")
    @GetMapping("/admin/stickers")
    @AdminOnly
    public ResponseEntity<Page<StickerDto>> getAllStickersAdmin(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        Page<StickerDto> stickers = stickersService.getAllStickersAdmin(page, size);
        return ResponseEntity.ok(stickers);
    }

    @Operation(summary = "Создать новый стикер (только для администратора)")
    @PostMapping("/admin/stickers")
    @AdminOnly
    public ResponseEntity<StickerDto> createSticker(@RequestBody StickerCreateRequest request) {
        StickerDto sticker = stickersService.createSticker(request);
        return ResponseEntity.ok(sticker);
    }

    @Operation(summary = "Обновить стикер (только для администратора)")
    @PutMapping("/admin/stickers/{stickerId}")
    @AdminOnly
    public ResponseEntity<StickerDto> updateSticker(
            @PathVariable UUID stickerId,
            @RequestBody StickerUpdateRequest request) {
        StickerDto sticker = stickersService.updateSticker(stickerId, request);
        return ResponseEntity.ok(sticker);
    }

    @Operation(summary = "Удалить стикер (только для администратора)")
    @DeleteMapping("/admin/stickers/{stickerId}")
    @AdminOnly
    public ResponseEntity<Void> deleteSticker(@PathVariable UUID stickerId) {
        stickersService.deleteSticker(stickerId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить стикер по ID (только для администратора)")
    @GetMapping("/admin/stickers/{stickerId}")
    @AdminOnly
    public ResponseEntity<StickerDto> getStickerAdmin(@PathVariable UUID stickerId) {
        StickerDto sticker = stickersService.getStickerAdmin(stickerId);
        return ResponseEntity.ok(sticker);
    }

    @Operation(summary = "Получить статистику по стикерам (только для администратора)")
    @GetMapping("/admin/statistics")
    @AdminOnly
    public ResponseEntity<StickerStatisticsResponse> getStickerStatistics() {
        StickerStatisticsResponse statistics = stickersService.getStickerStatistics();
        return ResponseEntity.ok(statistics);
    }

    @Operation(summary = "Массовое удаление стикеров (только для администратора)")
    @DeleteMapping("/admin/stickers/bulk")
    @AdminOnly
    public ResponseEntity<Void> bulkDeleteStickers(@RequestBody List<UUID> stickerIds) {
        stickersService.bulkDeleteStickers(stickerIds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Массовое удаление стикерпаков (только для администратора)")
    @DeleteMapping("/admin/packs/bulk")
    @AdminOnly
    public ResponseEntity<Void> bulkDeleteStickerPacks(@RequestBody List<UUID> packIds) {
        stickersService.bulkDeleteStickerPacks(packIds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Экспорт всех стикерпаков (только для администратора)")
    @GetMapping("/admin/packs/export")
    @AdminOnly
    public ResponseEntity<List<StickerPackDto>> exportAllStickerPacks() {
        List<StickerPackDto> packs = stickersService.exportAllStickerPacks();
        return ResponseEntity.ok(packs);
    }

    @Operation(summary = "Экспорт всех стикеров (только для администратора)")
    @GetMapping("/admin/stickers/export")
    @AdminOnly
    public ResponseEntity<List<StickerDto>> exportAllStickers() {
        List<StickerDto> stickers = stickersService.exportAllStickers();
        return ResponseEntity.ok(stickers);
    }

    @GetMapping("/packs")
    public List<StickerPackDto> getAllStickerPacks() {
        return stickersService.getAllStickerPacks();
    }

    @GetMapping("/packs/{packId}")
    public StickerPackDto getStickerPack(@PathVariable UUID packId) {
        return stickersService.getStickerPack(packId);
    }

    @GetMapping("/packs/{packId}/stickers")
    public List<StickerDto> getStickersByPack(@PathVariable UUID packId) {
        return stickersService.getStickersByPack(packId);
    }

    @GetMapping("/{stickerId}")
    public StickerDto getSticker(@PathVariable UUID stickerId) {
        return stickersService.getSticker(stickerId);
    }
}