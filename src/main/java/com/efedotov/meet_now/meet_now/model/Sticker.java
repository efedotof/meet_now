package com.efedotov.meet_now.meet_now.model;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Data;

@Data
@Entity
@Table(
    name = "sticker",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"pack_id", "emoji"})
    }
)
public class Sticker {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pack_id", nullable = false)
    private StickerPack pack;

    @Column(nullable = false, length = 100)
    private String emoji;

    @Column(name = "image_url", nullable = false, columnDefinition = "TEXT")
    private String imageUrl;
}
