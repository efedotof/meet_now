package com.efedotov.meet_now.meet_now.repository.game;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.chat.ChatGame;

@Repository
public interface GamesRepository extends JpaRepository<ChatGame, UUID> {
    @Query("SELECT g FROM ChatGame g WHERE g.chat.id = :chatId")
    List<ChatGame> findByChatId(@Param("chatId") UUID chatId);
}