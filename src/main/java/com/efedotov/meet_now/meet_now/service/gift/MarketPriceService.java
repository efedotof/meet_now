package com.efedotov.meet_now.meet_now.service.gift;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.gift.Gift;
import com.efedotov.meet_now.meet_now.model.gift.MarketSettings;
import com.efedotov.meet_now.meet_now.repository.gift.GiftRepository;
import com.efedotov.meet_now.meet_now.repository.gift.MarketSettingsRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import jakarta.annotation.PostConstruct;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class MarketPriceService {

    private final UserRepository userRepository;
    private final GiftRepository giftRepository;
    private final MarketSettingsRepository settingsRepository;

    private final Map<UUID, Integer> currentPrices = new ConcurrentHashMap<>();

    private double calculateAverageBalance() {
        long totalPoints = userRepository.sumGamePoints();
        long userCount = userRepository.count();
        if (userCount == 0)
            return 0;
        return (double) totalPoints / userCount;
    }

    private double calculateMedianBalance() {
        List<Integer> points = userRepository.findAllGamePoints();
        if (points.isEmpty())
            return 0;
        Collections.sort(points);
        int size = points.size();
        if (size % 2 == 0) {
            return (points.get(size / 2 - 1) + points.get(size / 2)) / 2.0;
        } else {
            return points.get(size / 2);
        }
    }

    private double getBalanceMetric() {
        MarketSettings settings = settingsRepository.findById(1L).orElse(new MarketSettings());
        if (Boolean.TRUE.equals(settings.getUseMedian())) {
            return calculateMedianBalance();
        } else {
            return calculateAverageBalance();
        }
    }

    public int calculatePrice(Gift gift) {
        int basePrice = gift.getCostPoints();
        double balance = getBalanceMetric();
        MarketSettings settings = settingsRepository.findById(1L).orElse(new MarketSettings());
        int constant = Optional.ofNullable(settings.getBaseConstant()).orElse(1000);
        double maxMultiplier = Optional.ofNullable(settings.getMaxMultiplier()).orElse(3.0);
        double divisor = balance + constant;
        double addition = (divisor > 0) ? basePrice / divisor : 0;
        int rawPrice = (int) Math.round(basePrice + addition);

        int minPrice = basePrice;
        int maxPrice = (int) Math.round(basePrice * maxMultiplier);
        int finalPrice = Math.min(maxPrice, Math.max(minPrice, rawPrice));

        log.debug("Gift {}: base={}, balance={}, addition={}, final={}",
                gift.getId(), basePrice, balance, addition, finalPrice);
        return finalPrice;
    }

    @Scheduled(cron = "0 0 3 * * *")
    @Transactional
    public void updateAllPrices() {
        log.info("Starting market price update...");
        List<Gift> gifts = giftRepository.findAllByIsActiveTrue();
        MarketSettings settings = settingsRepository.findById(1L).orElse(new MarketSettings());

        for (Gift gift : gifts) {
            int newPrice = calculatePrice(gift);
            currentPrices.put(gift.getId(), newPrice);

            gift.setCurrentPrice(newPrice);
            giftRepository.save(gift);
        }
        settings.setLastUpdated(LocalDateTime.now());
        settingsRepository.save(settings);
        log.info("Updated prices for {} gifts", gifts.size());
    }

    public int getCurrentPrice(Gift gift) {
        return currentPrices.getOrDefault(gift.getId(), calculatePrice(gift));
    }

    @PostConstruct
    public void init() {
        updateAllPrices();
    }
}
