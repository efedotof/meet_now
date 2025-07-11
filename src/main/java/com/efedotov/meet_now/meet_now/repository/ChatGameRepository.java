package com.efedotov.meet_now.meet_now.repository;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.ChatGame;

@Repository
public interface ChatGameRepository extends JpaRepository<ChatGame, UUID> {
    List<ChatGame> findByChat_ChatId(UUID chatId);

    List<ChatGame> findByGameType(String gameType);
}
