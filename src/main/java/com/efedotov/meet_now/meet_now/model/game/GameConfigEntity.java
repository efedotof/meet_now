package com.efedotov.meet_now.meet_now.model.game;

import java.math.BigDecimal;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "game_configs")
public class GameConfigEntity {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "game_type", unique = true, nullable = false)
    private String gameType;

    @Column(name = "game_url", nullable = false)
    private String gameUrl;

    @Column(name = "score_multiplier", nullable = false, precision = 5, scale = 2)
    private BigDecimal scoreMultiplier;

    @Column(name = "game_name", nullable = false)
    private String gameName;

    @Column(name = "game_description", columnDefinition = "TEXT")
    private String gameDescription;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "thumbnail_url")
    private String thumbnailUrl;
}