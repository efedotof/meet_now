package com.efedotov.meet_now.meet_now.model.gift;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "market_settings")
@Data
public class MarketSettings {
    @Id
    private Long id = 1L;

    @Column(name = "base_constant")
    private Integer baseConstant = 1000;

    @Column(name = "max_multiplier")
    private Double maxMultiplier = 3.0;

    @Column(name = "update_cron")
    private String updateCron = "0 0 3 * * *";

    @Column(name = "use_median")
    private Boolean useMedian = false;

    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
}