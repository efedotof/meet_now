package com.efedotov.meet_now.meet_now.repository.user;

import com.efedotov.meet_now.meet_now.model.search.MatchDeliveryState;
import com.efedotov.meet_now.meet_now.model.search.MatchDeliveryStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface MatchDeliveryStateRepository extends JpaRepository<MatchDeliveryState, UUID> {

    Optional<MatchDeliveryState> findByChatId(UUID chatId);

    List<MatchDeliveryState> findByUser1IdOrUser2Id(UUID user1Id, UUID user2Id);

    @Query("SELECT m FROM MatchDeliveryState m WHERE " +
            "(m.user1Id = :userId OR m.user2Id = :userId) " +
            "AND m.status = :status")
    List<MatchDeliveryState> findByUserIdAndStatus(
            @Param("userId") UUID userId,
            @Param("status") MatchDeliveryStatus status);

    @Query("SELECT m FROM MatchDeliveryState m WHERE " +
            "m.status IN :statuses " +
            "AND m.createdAt < :cutoff")
    List<MatchDeliveryState> findExpiredDeliveries(
            @Param("statuses") List<MatchDeliveryStatus> statuses,
            @Param("cutoff") LocalDateTime cutoff);

    void deleteByChatId(UUID chatId);
}
