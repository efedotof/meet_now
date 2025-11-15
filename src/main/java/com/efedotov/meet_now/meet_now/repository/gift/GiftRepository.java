package com.efedotov.meet_now.meet_now.repository.gift;

import com.efedotov.meet_now.meet_now.model.gift.Gift;
import com.efedotov.meet_now.meet_now.model.gift.GiftRarity;
import org.springframework.data.jpa.repository.JpaRepository;
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
}