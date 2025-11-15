package com.efedotov.meet_now.meet_now.repository.content;

import com.efedotov.meet_now.meet_now.model.content.StickerPack;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface StickerPackRepository extends JpaRepository<StickerPack, UUID> {
    Optional<StickerPack> findByTitle(String title);

    Page<StickerPack> findByTitleContainingIgnoreCase(String title, Pageable pageable);
}