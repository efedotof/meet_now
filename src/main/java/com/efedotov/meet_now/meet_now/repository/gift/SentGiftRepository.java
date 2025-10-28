package com.efedotov.meet_now.meet_now.repository.gift;

import com.efedotov.meet_now.meet_now.model.gift.SentGift;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface SentGiftRepository extends JpaRepository<SentGift, UUID> {
    
    List<SentGift> findBySenderIdOrderBySentAtDesc(UUID senderId);
    
    List<SentGift> findByRecipientIdOrderBySentAtDesc(UUID recipientId);
    
    Page<SentGift> findBySenderIdOrderBySentAtDesc(UUID senderId, Pageable pageable);
    
    Page<SentGift> findByRecipientIdOrderBySentAtDesc(UUID recipientId, Pageable pageable);
    
    @Query("SELECT sg FROM SentGift sg WHERE (sg.sender.id = :userId OR sg.recipient.id = :userId) ORDER BY sg.sentAt DESC")
    List<SentGift> findByUserId(@Param("userId") UUID userId);
    
    @Query("SELECT sg FROM SentGift sg WHERE sg.chat.id = :chatId ORDER BY sg.sentAt DESC")
    List<SentGift> findByChatId(@Param("chatId") UUID chatId);
    
    @Query("SELECT sg FROM SentGift sg WHERE sg.tempChat.id = :tempChatId ORDER BY sg.sentAt DESC")
    List<SentGift> findByTempChatId(@Param("tempChatId") UUID tempChatId);
    
    @Query("SELECT COUNT(sg) FROM SentGift sg WHERE sg.sender.id = :userId")
    Long countBySenderId(@Param("userId") UUID userId);
    
    @Query("SELECT COUNT(sg) FROM SentGift sg WHERE sg.recipient.id = :userId")
    Long countByRecipientId(@Param("userId") UUID userId);
}