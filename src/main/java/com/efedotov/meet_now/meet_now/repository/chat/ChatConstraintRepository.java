package com.efedotov.meet_now.meet_now.repository.chat;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.ChatConstraint;

@Repository
public interface ChatConstraintRepository extends JpaRepository<ChatConstraint, UUID> {
    Optional<ChatConstraint> findByTemporaryChat_TempChatId(UUID tempChatId);
}
