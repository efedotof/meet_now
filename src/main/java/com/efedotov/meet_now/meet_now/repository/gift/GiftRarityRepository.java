package com.efedotov.meet_now.meet_now.repository.gift;

import com.efedotov.meet_now.meet_now.model.gift.GiftRarity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface GiftRarityRepository extends JpaRepository<GiftRarity, UUID> {
    
    Optional<GiftRarity> findByName(String name);
    
    List<GiftRarity> findByIsActiveTrue();
    
    @Query("SELECT gr FROM GiftRarity gr WHERE gr.isActive = true AND gr.minPoints <= :points AND gr.maxPoints >= :points")
    List<GiftRarity> findActiveByPointsRange(@Param("points") Integer points);
    
    @Query("SELECT gr FROM GiftRarity gr WHERE gr.isActive = true ORDER BY gr.probability DESC")
    List<GiftRarity> findActiveByProbability();
}