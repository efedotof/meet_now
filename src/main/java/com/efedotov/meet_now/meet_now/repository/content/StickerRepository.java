package com.efedotov.meet_now.meet_now.repository.content;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.efedotov.meet_now.meet_now.dto.response.content.EmojiStatsDTO;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerPackStatsDTO;
import com.efedotov.meet_now.meet_now.model.content.Sticker;
import com.efedotov.meet_now.meet_now.model.content.StickerPack;

public interface StickerRepository extends JpaRepository<Sticker, UUID> {
    List<Sticker> findByPackId(UUID packId);

    Page<Sticker> findByPackId(UUID packId, Pageable pageable);

    List<Sticker> findByPackTitle(String packTitle);

    boolean existsByPackAndEmoji(StickerPack pack, String emoji);

    @Query("SELECT NEW com.efedotov.meet_now.meet_now.dto.response.content.StickerPackStatsDTO(s.pack.title, COUNT(s)) " +
            "FROM Sticker s GROUP BY s.pack.id, s.pack.title")
    List<StickerPackStatsDTO> countStickersPerPack();

    @Query("SELECT NEW com.efedotov.meet_now.meet_now.dto.response.content.EmojiStatsDTO(s.emoji, COUNT(s)) " +
            "FROM Sticker s GROUP BY s.emoji ORDER BY COUNT(s) DESC")
    List<EmojiStatsDTO> findMostPopularEmojis();

    @Query("SELECT s FROM Sticker s LEFT JOIN FETCH s.pack WHERE s.id = :id")
    Optional<Sticker> findByIdWithPack(UUID id);
}