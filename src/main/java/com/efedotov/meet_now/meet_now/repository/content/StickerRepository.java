package com.efedotov.meet_now.meet_now.repository.content;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.efedotov.meet_now.meet_now.model.content.Sticker;

public interface StickerRepository extends JpaRepository<Sticker, UUID> {
    List<Sticker> findByPackId(UUID packId);
}
