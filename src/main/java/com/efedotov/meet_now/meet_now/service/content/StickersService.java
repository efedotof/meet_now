package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.content.StickerDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerPackDto;
import com.efedotov.meet_now.meet_now.model.content.Sticker;
import com.efedotov.meet_now.meet_now.model.content.StickerPack;
import com.efedotov.meet_now.meet_now.repository.content.StickerPackRepository;
import com.efedotov.meet_now.meet_now.repository.content.StickerRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StickersService {
    private final StickerPackRepository stickerPackRepository;
    private final StickerRepository stickerRepository;

    public List<StickerPackDto> getAllStickerPacks() {
        return stickerPackRepository.findAll().stream()
                .map(this::convertToStickerPackDto)
                .toList();
    }

    public StickerPackDto getStickerPack(UUID packId) {
        StickerPack pack = stickerPackRepository.findById(packId)
                .orElseThrow(() -> new RuntimeException("Sticker pack not found: " + packId));
        return convertToStickerPackDto(pack);
    }

    public List<StickerDto> getStickersByPack(UUID packId) {
        return stickerRepository.findByPackId(packId).stream()
                .map(this::convertToStickerDto)
                .toList();
    }

    public StickerDto getSticker(UUID stickerId) {
        Sticker sticker = stickerRepository.findById(stickerId)
                .orElseThrow(() -> new RuntimeException("Sticker not found: " + stickerId));
        return convertToStickerDto(sticker);
    }

    private StickerPackDto convertToStickerPackDto(StickerPack pack) {
        StickerPackDto dto = new StickerPackDto();
        dto.setId(pack.getId());
        dto.setTitle(pack.getTitle());
        dto.setStickers(pack.getStickers().stream()
                .map(this::convertToStickerDto)
                .toList());
        return dto;
    }

    private StickerDto convertToStickerDto(Sticker sticker) {
        StickerDto dto = new StickerDto();
        dto.setId(sticker.getId());
        dto.setEmoji(sticker.getEmoji());
        dto.setImageUrl(sticker.getImageUrl());
        return dto;
    }
}