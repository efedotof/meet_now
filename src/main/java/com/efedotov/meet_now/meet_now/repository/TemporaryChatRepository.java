package com.efedotov.meet_now.meet_now.repository;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.TemporaryChat;

@Repository
public interface TemporaryChatRepository extends JpaRepository<TemporaryChat, UUID> {
    List<TemporaryChat> findBySender_IdOrRecipient_Id(UUID senderId, UUID recipientId);

    List<TemporaryChat> findByIsFinishedFalse();
}
