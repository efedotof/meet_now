package com.efedotov.meet_now.meet_now.repository.chat;

import com.efedotov.meet_now.meet_now.model.user.FreeSearchUsage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;

public interface FreeSearchUsageRepository extends JpaRepository<FreeSearchUsage, UUID> {
    Optional<FreeSearchUsage> findByUserId(UUID userId);

    @Query("SELECT f FROM FreeSearchUsage f WHERE f.userId = :userId AND f.usedDate = :date")
    Optional<FreeSearchUsage> findByUserIdAndUsedDate(@Param("userId") UUID userId, @Param("date") LocalDate date);
}