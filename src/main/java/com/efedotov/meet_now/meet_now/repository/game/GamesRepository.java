package com.efedotov.meet_now.meet_now.repository.game;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.dto.response.game.GameTypeStatsDTO;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;

@Repository
public interface GamesRepository extends JpaRepository<ChatGame, UUID>, JpaSpecificationExecutor<ChatGame> {

    @Query("SELECT cg FROM ChatGame cg WHERE cg.chat.chatId = :chatId")
    List<ChatGame> findByChatId(@Param("chatId") UUID chatId);

    @Query("SELECT COUNT(g) FROM ChatGame g WHERE g.chat IS NOT NULL")
    long countByChatIsNotNull();

    @Query("SELECT COUNT(g) FROM ChatGame g WHERE g.chat IS NULL")
    long countByChatIsNull();

    @Query("SELECT g.gameType, COUNT(g) FROM ChatGame g GROUP BY g.gameType")
    List<Object[]> countGamesByType();

    @Query("SELECT NEW com.efedotov.meet_now.meet_now.dto.response.game.GameTypeStatsDTO(g.gameType, COUNT(g)) " +
            "FROM ChatGame g GROUP BY g.gameType ORDER BY COUNT(g) DESC")
    List<GameTypeStatsDTO> findMostPopularGameTypes();

    Page<ChatGame> findByGameType(String gameType, Pageable pageable);

    @Modifying
    @Query("DELETE FROM ChatGame g WHERE g.id IN :ids")
    int deleteByIdIn(@Param("ids") List<UUID> ids);

    @Query("SELECT g FROM ChatGame g WHERE g.createdAt BETWEEN :start AND :end")
    List<ChatGame> findByCreatedAtBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT g FROM ChatGame g WHERE g.createdAt >= :start")
    List<ChatGame> findByCreatedAtAfter(@Param("start") LocalDateTime start);

    @Query("SELECT g FROM ChatGame g WHERE g.createdAt <= :end")
    List<ChatGame> findByCreatedAtBefore(@Param("end") LocalDateTime end);

    @Modifying
    @Query("DELETE FROM ChatGame g WHERE g.createdAt < :cutoffDate")
    int deleteByCreatedAtBefore(@Param("cutoffDate") LocalDateTime cutoffDate);
}