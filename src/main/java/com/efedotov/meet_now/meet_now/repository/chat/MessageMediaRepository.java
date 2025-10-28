package com.efedotov.meet_now.meet_now.repository.chat;

import com.efedotov.meet_now.meet_now.model.chat.MessageMedia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface MessageMediaRepository extends JpaRepository<MessageMedia, UUID> {
    
    List<MessageMedia> findByMessageIdOrderBySortOrderAsc(UUID messageId);
    
    @Query("SELECT mm FROM MessageMedia mm WHERE mm.message.id IN :messageIds ORDER BY mm.message.id, mm.sortOrder")
    List<MessageMedia> findByMessageIds(@Param("messageIds") List<UUID> messageIds);
    
    void deleteByMessageId(UUID messageId);
}