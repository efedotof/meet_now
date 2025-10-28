package com.efedotov.meet_now.meet_now.repository.gift;

import com.efedotov.meet_now.meet_now.model.gift.DailyGift;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface DailyGiftRepository extends JpaRepository<DailyGift, UUID> {

    @Query("SELECT dg FROM DailyGift dg WHERE dg.user.id = :userId AND FUNCTION('DATE', dg.receivedAt) = CURRENT_DATE")
    Optional<DailyGift> findTodayByUserId(@Param("userId") UUID userId);

    @Query("SELECT dg FROM DailyGift dg WHERE dg.user.id = :userId AND dg.receivedAt >= :startOfDay AND dg.receivedAt < :endOfDay")
    Optional<DailyGift> findTodayByUserIdRange(@Param("userId") UUID userId,
            @Param("startOfDay") LocalDateTime startOfDay,
            @Param("endOfDay") LocalDateTime endOfDay);

    @Query("SELECT dg FROM DailyGift dg WHERE dg.user.id = :userId AND dg.receivedAt >= :startDate ORDER BY dg.receivedAt DESC")
    List<DailyGift> findByUserIdAndDateAfter(@Param("userId") UUID userId, @Param("startDate") LocalDateTime startDate);

    @Query("SELECT MAX(dg.streakCount) FROM DailyGift dg WHERE dg.user.id = :userId")
    Integer findMaxStreakByUserId(@Param("userId") UUID userId);

    @Query("SELECT dg FROM DailyGift dg WHERE dg.user.id = :userId ORDER BY dg.receivedAt DESC")
    List<DailyGift> findLatestByUserId(@Param("userId") UUID userId, org.springframework.data.domain.Pageable pageable);

    default Optional<DailyGift> findLatestByUserId(UUID userId) {
        List<DailyGift> result = findLatestByUserId(userId, org.springframework.data.domain.PageRequest.of(0, 1));
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    default Optional<DailyGift> findTodayByUserIdWithRange(UUID userId) {
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.plusDays(1).atStartOfDay();
        return findTodayByUserIdRange(userId, startOfDay, endOfDay);
    }
}