package com.efedotov.meet_now.meet_now.repository.swipe;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.swipe.Match;

@Repository
public interface MatchRepository extends JpaRepository<Match, UUID> {
    List<Match> findByUser1IdOrUser2Id(UUID user1Id, UUID user2Id);

    @Query("SELECT m FROM Match m WHERE (m.user1Id = :userId AND m.user2Id = :otherId) OR (m.user1Id = :otherId AND m.user2Id = :userId)")
    Optional<Match> findByUsers(@Param("userId") UUID userId, @Param("otherId") UUID otherId);

    boolean existsByUser1IdAndUser2Id(UUID user1Id, UUID user2Id);

    @Query("SELECT COUNT(m) > 0 FROM Match m WHERE (m.user1Id = :userId AND m.user2Id = :otherId) OR (m.user1Id = :otherId AND m.user2Id = :userId)")
    boolean existsMatchBetweenUsers(@Param("userId") UUID userId, @Param("otherId") UUID otherId);
}