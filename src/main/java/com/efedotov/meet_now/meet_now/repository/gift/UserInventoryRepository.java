package com.efedotov.meet_now.meet_now.repository.gift;

import com.efedotov.meet_now.meet_now.model.gift.UserInventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserInventoryRepository extends JpaRepository<UserInventory, UUID> {

        List<UserInventory> findByUserIdAndIsVisibleTrue(UUID userId);

        List<UserInventory> findByUserId(UUID userId);

        Optional<UserInventory> findByUserIdAndGiftId(UUID userId, UUID giftId);

        @Query("SELECT ui FROM UserInventory ui WHERE ui.user.id = :userId AND ui.gift.id = :giftId AND ui.receivedFrom.id = :receivedFromId")
        Optional<UserInventory> findByUserAndGiftAndReceivedFrom(
                        @Param("userId") UUID userId,
                        @Param("giftId") UUID giftId,
                        @Param("receivedFromId") UUID receivedFromId);

        @Query("SELECT ui FROM UserInventory ui WHERE ui.user.id = :userId AND ui.receivedFrom.id = :receivedFromId")
        List<UserInventory> findByUserIdAndReceivedFromId(@Param("userId") UUID userId,
                        @Param("receivedFromId") UUID receivedFromId);

        @Query("SELECT COUNT(ui) FROM UserInventory ui WHERE ui.user.id = :userId")
        Long countByUserId(@Param("userId") UUID userId);

        @Query("SELECT ui.gift.id, SUM(ui.quantity) FROM UserInventory ui WHERE ui.user.id = :userId GROUP BY ui.gift.id")
        List<Object[]> countGiftsByUserId(@Param("userId") UUID userId);

        long countByGiftId(UUID giftId);
}