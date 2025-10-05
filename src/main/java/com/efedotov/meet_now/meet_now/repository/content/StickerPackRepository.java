package com.efedotov.meet_now.meet_now.repository.content;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.efedotov.meet_now.meet_now.model.content.StickerPack;

public interface StickerPackRepository extends JpaRepository<StickerPack, UUID> {

}
