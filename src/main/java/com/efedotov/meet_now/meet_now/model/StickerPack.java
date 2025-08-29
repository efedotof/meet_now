package com.efedotov.meet_now.meet_now.model;

import java.util.List;
import java.util.UUID;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "sticker_pack")
public class StickerPack {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false, unique = true, length = 100)
    private String title;

    @OneToMany(mappedBy = "pack", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Sticker> stickers;
}
