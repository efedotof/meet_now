package com.efedotov.meet_now.meet_now.repository;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.Chat;

@Repository
public interface ChatRepository extends JpaRepository<Chat, UUID> {
    List<Chat> findByUser1IdOrUser2Id(UUID user1Id, UUID user2Id);
    Optional<Chat> findByUser1IdAndUser2Id(UUID user1Id, UUID user2Id);
    List<Chat> findByIsOpened(Boolean isOpened);
}
