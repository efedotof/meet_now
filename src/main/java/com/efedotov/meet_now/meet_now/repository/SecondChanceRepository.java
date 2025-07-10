package com.efedotov.meet_now.meet_now.repository;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.ChatConstraint;
import com.efedotov.meet_now.meet_now.model.SecondChance;

@Repository
public interface SecondChanceRepository extends JpaRepository<SecondChance, UUID> {
    Optional<ChatConstraint> findByTemporaryChat_TempChatId(UUID tempChatId);
}
