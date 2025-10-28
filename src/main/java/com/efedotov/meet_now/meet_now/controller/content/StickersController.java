package com.efedotov.meet_now.meet_now.controller.content;

import java.util.List;
import java.util.UUID;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.response.content.StickerDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerPackDto;
import com.efedotov.meet_now.meet_now.service.content.StickersService;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/stickers")
@Tag(name = "Stickers", description = "Управление стикерами и стикерпаками")
@RequiredArgsConstructor
public class StickersController {

    private final StickersService stickersService;

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