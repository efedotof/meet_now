package com.efedotov.meet_now.meet_now.repository.gift;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.gift.MarketSettings;

@Repository
public interface MarketSettingsRepository extends JpaRepository<MarketSettings, Long> {
}
