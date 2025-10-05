package com.efedotov.meet_now.meet_now.repository.chat;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;

@Repository
public interface TemporaryChatRepository extends JpaRepository<TemporaryChat, UUID> {
    List<TemporaryChat> findBySender_IdOrRecipient_Id(UUID senderId, UUID recipientId);

    List<TemporaryChat> findByIsFinishedFalse();

    @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END " +
            "FROM TemporaryChat t WHERE t.tempChatId = :tempChatId " +
            "AND (t.sender.id = :userId OR t.recipient.id = :userId)")
    boolean existsByTempChatIdAndUserId(@Param("tempChatId") UUID tempChatId,
            @Param("userId") UUID userId);
}
