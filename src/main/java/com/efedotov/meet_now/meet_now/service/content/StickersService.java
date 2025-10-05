package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

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

    public List<StickerPack> getAllStickerPacks() {
        return stickerPackRepository.findAll();
    }

    public StickerPack getStickerPack(UUID packId) {
        return stickerPackRepository.findById(packId)
                .orElseThrow(() -> new RuntimeException("Sticker pack not found: " + packId));
    }

    public List<Sticker> getStickersByPack(UUID packId) {
        return stickerRepository.findByPackId(packId);
    }

    public Sticker getSticker(UUID stickerId) {
        return stickerRepository.findById(stickerId)
                .orElseThrow(() -> new RuntimeException("Sticker not found: " + stickerId));
    }
}
