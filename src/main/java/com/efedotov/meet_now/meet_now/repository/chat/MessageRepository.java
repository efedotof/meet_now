package com.efedotov.meet_now.meet_now.repository.chat;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.chat.ChatGame;
import com.efedotov.meet_now.meet_now.model.chat.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, UUID> {
    List<ChatGame> findByChat_ChatId(UUID chatId);

    List<Message> findBySender_Id(UUID senderId);

    List<Message> findByRecipient_Id(UUID recipientId);

    List<Message> findByChat_ChatIdOrderByCreatedAtAsc(UUID chatId);

    List<Message> findByTemporaryChat_TempChatIdOrderByCreatedAtAsc(UUID tempChatId);

    @Query("SELECT m FROM Message m WHERE m.id IN :messageIds")
    List<Message> findAllByIds(@Param("messageIds") List<UUID> messageIds);

    @Query("SELECT COUNT(m) FROM Message m WHERE m.chat.chatId = :chatId AND m.recipient.id = :userId AND m.isRead = false")
    Long countUnreadMessagesInChat(@Param("chatId") UUID chatId, @Param("userId") UUID userId);

    Long countByChat_ChatId(UUID chatId);

}
