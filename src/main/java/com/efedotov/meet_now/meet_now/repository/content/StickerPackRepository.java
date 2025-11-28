package com.efedotov.meet_now.meet_now.repository.content;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.efedotov.meet_now.meet_now.model.content.StickerPack;

public interface StickerPackRepository extends JpaRepository<StickerPack, UUID> {
    Optional<StickerPack> findByTitle(String title);

    Page<StickerPack> findByTitleContainingIgnoreCase(String title, Pageable pageable);

    @Query("SELECT DISTINCT sp FROM StickerPack sp LEFT JOIN FETCH sp.stickers")
    List<StickerPack> findAllWithStickers();

    @Query("SELECT DISTINCT sp FROM StickerPack sp LEFT JOIN FETCH sp.stickers WHERE sp.id = :id")
    Optional<StickerPack> findByIdWithStickers(UUID id);

    @Query("SELECT sp FROM StickerPack sp LEFT JOIN FETCH sp.stickers")
    Page<StickerPack> findAllWithStickers(Pageable pageable);

    @Query("SELECT sp FROM StickerPack sp LEFT JOIN FETCH sp.stickers WHERE LOWER(sp.title) LIKE LOWER(CONCAT('%', :title, '%'))")
    Page<StickerPack> findByTitleContainingIgnoreCaseWithStickers(String title, Pageable pageable);
}