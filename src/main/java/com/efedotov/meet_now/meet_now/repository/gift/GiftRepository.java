package com.efedotov.meet_now.meet_now.repository.gift;

import com.efedotov.meet_now.meet_now.model.gift.Gift;
import com.efedotov.meet_now.meet_now.model.gift.GiftRarity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface GiftRepository extends JpaRepository<Gift, UUID> {

    List<Gift> findByIsActiveTrue();

    List<Gift> findByGiftTypeTypeNameAndIsActiveTrue(String typeName);

    List<Gift> findByRarityAndIsActiveTrue(GiftRarity rarity);

    @Query("SELECT g FROM Gift g WHERE g.costPoints BETWEEN :minCost AND :maxCost AND g.isActive = true")
    List<Gift> findByCostRange(@Param("minCost") Integer minCost, @Param("maxCost") Integer maxCost);

    List<Gift> findByCostPointsLessThanEqualAndIsActiveTrue(Integer maxCost);

    @Query("SELECT g FROM Gift g WHERE g.costPoints BETWEEN :minCost AND :maxCost AND g.isActive = true")
    List<Gift> findByCostPointsBetweenAndIsActiveTrue(@Param("minCost") Integer minCost,
            @Param("maxCost") Integer maxCost);

    @Query("SELECT g FROM Gift g WHERE g.id = :id AND g.isActive = true")
    Optional<Gift> findByIdAndIsActiveTrue(@Param("id") UUID id);

    long countByIsActiveTrue();

    List<Gift> findByRarity(GiftRarity rarity);

    @Query("SELECT g FROM Gift g WHERE g.isActive = true AND (g.isLimited = false OR (g.isLimited = true AND g.isSoldOut = false))")
    List<Gift> findAvailableForPurchase();

    @Query("SELECT COUNT(g) FROM Gift g WHERE g.isActive = true AND g.isLimited = true AND g.isSoldOut = false")
    long countAvailableLimitedGifts();

    @Modifying
    @Query("UPDATE Gift g SET g.availableQuantity = g.availableQuantity - :quantity, g.soldCount = g.soldCount + :quantity WHERE g.id = :giftId AND (g.availableQuantity IS NULL OR g.availableQuantity >= :quantity)")
    int decreaseGiftQuantity(@Param("giftId") UUID giftId, @Param("quantity") Integer quantity);

    @Query("SELECT g FROM Gift g WHERE g.isLimited = true AND g.isSoldOut = false AND g.isActive = true")
    List<Gift> findLimitedAvailableGifts();

    @Query("SELECT g FROM Gift g WHERE g.isLimited = true AND g.isSoldOut = true AND g.isActive = true")
    List<Gift> findSoldOutGifts();
}