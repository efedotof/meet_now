package com.efedotov.meet_now.meet_now.repository.chat;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;

@Repository
public interface ChatGameRepository extends JpaRepository<ChatGame, UUID> {
    @Query("SELECT cg FROM ChatGame cg WHERE cg.chat.chatId = :chatId")
    List<ChatGame> findByChatId(UUID chatId);

    List<ChatGame> findByGameType(String gameType);

}