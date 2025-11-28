package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.request.content.StickerCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.StickerPackCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.StickerPackUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.StickerUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.content.EmojiStatsDTO;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerPackDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerPackStatsDTO;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.content.Sticker;
import com.efedotov.meet_now.meet_now.model.content.StickerPack;
import com.efedotov.meet_now.meet_now.repository.content.StickerPackRepository;
import com.efedotov.meet_now.meet_now.repository.content.StickerRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class StickersService {
    private final StickerPackRepository stickerPackRepository;
    private final StickerRepository stickerRepository;

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<StickerPackDto> getAllStickerPacksAdmin(int page, int size, String search) {
        Pageable pageable = PageRequest.of(page, size);

        if (search != null && !search.trim().isEmpty()) {
            return stickerPackRepository.findByTitleContainingIgnoreCaseWithStickers(search.trim(), pageable)
                    .map(this::convertToStickerPackDto);
        }

        return stickerPackRepository.findAllWithStickers(pageable)
                .map(this::convertToStickerPackDto);
    }

    @AdminOnly
    @Transactional
    public StickerPackDto createStickerPack(StickerPackCreateRequest request) {
        if (stickerPackRepository.findByTitle(request.getTitle()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Стикерпак с названием '" + request.getTitle() + "' уже существует");
        }

        StickerPack pack = new StickerPack();
        pack.setTitle(request.getTitle());

        StickerPack savedPack = stickerPackRepository.save(pack);
        log.info("Создан новый стикерпак: {}", savedPack.getTitle());

        return convertToStickerPackDto(savedPack);
    }

    @AdminOnly
    @Transactional
    public StickerPackDto updateStickerPack(UUID packId, StickerPackUpdateRequest request) {
        StickerPack pack = stickerPackRepository.findById(packId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Стикерпак не найден"));

        if (request.getTitle() != null &&
                !request.getTitle().equals(pack.getTitle()) &&
                stickerPackRepository.findByTitle(request.getTitle()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Стикерпак с названием '" + request.getTitle() + "' уже существует");
        }

        if (request.getTitle() != null) {
            pack.setTitle(request.getTitle());
        }

        StickerPack updatedPack = stickerPackRepository.save(pack);
        log.info("Обновлен стикерпак: ID {}", packId);

        return convertToStickerPackDto(updatedPack);
    }

    @AdminOnly
    @Transactional
    public void deleteStickerPack(UUID packId) {
        StickerPack pack = stickerPackRepository.findById(packId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Стикерпак не найден"));

        stickerPackRepository.delete(pack);
        log.info("Удален стикерпак: {}", pack.getTitle());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public StickerPackDto getStickerPackAdmin(UUID packId) {
        StickerPack pack = stickerPackRepository.findByIdWithStickers(packId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Стикерпак не найден"));
        return convertToStickerPackDto(pack);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<StickerDto> getAllStickersAdmin(int page, int size, UUID packId) {
        Pageable pageable = PageRequest.of(page, size);

        if (packId != null) {
            return stickerRepository.findByPackId(packId, pageable)
                    .map(this::convertToStickerDto);
        }

        return stickerRepository.findAll(pageable)
                .map(this::convertToStickerDto);
    }

    @AdminOnly
    @Transactional
    public StickerDto createSticker(StickerCreateRequest request) {
        StickerPack pack = stickerPackRepository.findById(request.getPackId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Стикерпак не найден"));

        if (stickerRepository.existsByPackAndEmoji(pack, request.getEmoji())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Стикер с emoji '" + request.getEmoji() + "' уже существует в этом стикерпаке");
        }

        Sticker sticker = new Sticker();
        sticker.setPack(pack);
        sticker.setEmoji(request.getEmoji());
        sticker.setImageUrl(request.getImageUrl());

        Sticker savedSticker = stickerRepository.save(sticker);
        log.info("Создан новый стикер: {} в пачке {}", savedSticker.getEmoji(), pack.getTitle());

        return convertToStickerDto(savedSticker);
    }

    @AdminOnly
    @Transactional
    public StickerDto updateSticker(UUID stickerId, StickerUpdateRequest request) {
        Sticker sticker = stickerRepository.findById(stickerId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Стикер не найден"));

        if (request.getEmoji() != null &&
                !request.getEmoji().equals(sticker.getEmoji())) {
            if (stickerRepository.existsByPackAndEmoji(sticker.getPack(), request.getEmoji())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Стикер с emoji '" + request.getEmoji() + "' уже существует в этом стикерпаке");
            }
            sticker.setEmoji(request.getEmoji());
        }

        if (request.getImageUrl() != null) {
            sticker.setImageUrl(request.getImageUrl());
        }

        Sticker updatedSticker = stickerRepository.save(sticker);
        log.info("Обновлен стикер: ID {}", stickerId);

        return convertToStickerDto(updatedSticker);
    }

    @AdminOnly
    @Transactional
    public void deleteSticker(UUID stickerId) {
        Sticker sticker = stickerRepository.findById(stickerId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Стикер не найден"));

        stickerRepository.delete(sticker);
        log.info("Удален стикер: {}", sticker.getEmoji());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public StickerDto getStickerAdmin(UUID stickerId) {
        Sticker sticker = stickerRepository.findById(stickerId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Стикер не найден"));
        return convertToStickerDto(sticker);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public StickerStatisticsResponse getStickerStatistics() {
        long totalPacks = stickerPackRepository.count();
        long totalStickers = stickerRepository.count();

        List<StickerPackStatsDTO> stickersPerPack = stickerRepository.countStickersPerPack();
        List<EmojiStatsDTO> popularEmojis = stickerRepository.findMostPopularEmojis();

        return StickerStatisticsResponse.builder()
                .totalPacks(totalPacks)
                .totalStickers(totalStickers)
                .stickersPerPack(stickersPerPack)
                .popularEmojis(popularEmojis)
                .build();
    }

    @AdminOnly
    @Transactional
    public void bulkDeleteStickers(List<UUID> stickerIds) {
        if (stickerIds == null || stickerIds.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Список ID стикеров не может быть пустым");
        }

        long deletedCount = 0;
        for (UUID stickerId : stickerIds) {
            try {
                deleteSticker(stickerId);
                deletedCount++;
            } catch (Exception e) {
                log.warn("Не удалось удалить стикер с ID {}: {}", stickerId, e.getMessage());
            }
        }

        log.info("Удалено {} стикеров из {}", deletedCount, stickerIds.size());
    }

    @AdminOnly
    @Transactional
    public void bulkDeleteStickerPacks(List<UUID> packIds) {
        if (packIds == null || packIds.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Список ID стикерпаков не может быть пустым");
        }

        long deletedCount = 0;
        for (UUID packId : packIds) {
            try {
                deleteStickerPack(packId);
                deletedCount++;
            } catch (Exception e) {
                log.warn("Не удалось удалить стикерпак с ID {}: {}", packId, e.getMessage());
            }
        }

        log.info("Удалено {} стикерпаков из {}", deletedCount, packIds.size());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<StickerPackDto> exportAllStickerPacks() {
        return stickerPackRepository.findAllWithStickers().stream()
                .map(this::convertToStickerPackDto)
                .toList();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<StickerDto> exportAllStickers() {
        return stickerRepository.findAll().stream()
                .map(this::convertToStickerDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<StickerPackDto> getAllStickerPacks() {
        return stickerPackRepository.findAllWithStickers().stream()
                .map(this::convertToStickerPackDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public StickerPackDto getStickerPack(UUID packId) {
        StickerPack pack = stickerPackRepository.findByIdWithStickers(packId)
                .orElseThrow(() -> new RuntimeException("Sticker pack not found: " + packId));
        return convertToStickerPackDto(pack);
    }

    @Transactional(readOnly = true)
    public List<StickerDto> getStickersByPack(UUID packId) {
        return stickerRepository.findByPackId(packId).stream()
                .map(this::convertToStickerDto)
                .toList();
    }

    @Transactional(readOnly = true)
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