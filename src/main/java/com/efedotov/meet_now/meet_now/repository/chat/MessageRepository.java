package com.efedotov.meet_now.meet_now.repository.chat;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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

    @Query("SELECT m FROM Message m LEFT JOIN FETCH m.gift WHERE m.chat.chatId = :chatId ORDER BY m.createdAt ASC")
    List<Message> findByChat_ChatIdOrderByCreatedAtAsc(@Param("chatId") UUID chatId);

    @Query("SELECT m FROM Message m LEFT JOIN FETCH m.gift WHERE m.temporaryChat.tempChatId = :tempChatId ORDER BY m.createdAt ASC")
    List<Message> findByTemporaryChat_TempChatIdOrderByCreatedAtAsc(@Param("tempChatId") UUID tempChatId);

    @Query("SELECT m FROM Message m WHERE m.id IN :messageIds")
    List<Message> findAllByIds(@Param("messageIds") List<UUID> messageIds);

    @Query("SELECT COUNT(m) FROM Message m WHERE m.chat.chatId = :chatId AND m.recipient.id = :userId AND m.isRead = false")
    Long countUnreadMessagesInChat(@Param("chatId") UUID chatId, @Param("userId") UUID userId);

    Long countByChat_ChatId(UUID chatId);

    @Query("SELECT m FROM Message m LEFT JOIN FETCH m.gift WHERE m.isDeleted = false AND m.chat.chatId = :chatId ORDER BY m.createdAt ASC")
    List<Message> findNonDeletedMessagesByChatId(@Param("chatId") UUID chatId);

    @Query("SELECT m FROM Message m LEFT JOIN FETCH m.gift WHERE m.isDeleted = false AND m.temporaryChat.tempChatId = :tempChatId ORDER BY m.createdAt ASC")
    List<Message> findNonDeletedMessagesByTempChatId(@Param("tempChatId") UUID tempChatId);

    @Query("SELECT m FROM Message m LEFT JOIN FETCH m.gift WHERE m.chat.chatId = :chatId ORDER BY m.createdAt DESC")
    Page<Message> findMessagesByChatId(@Param("chatId") UUID chatId, Pageable pageable);

    @Query("SELECT m FROM Message m LEFT JOIN FETCH m.gift WHERE m.temporaryChat.tempChatId = :tempChatId ORDER BY m.createdAt DESC")
    Page<Message> findMessagesByTempChatId(@Param("tempChatId") UUID tempChatId, Pageable pageable);

    @Query("SELECT COUNT(m) FROM Message m WHERE m.chat.chatId = :chatId")
    Long countByChatId(@Param("chatId") UUID chatId);

    @Query("SELECT COUNT(m) FROM Message m WHERE m.temporaryChat.tempChatId = :tempChatId")
    Long countByTempChatId(@Param("tempChatId") UUID tempChatId);

    @Query("SELECT COUNT(m) FROM Message m WHERE m.chat.chatId = :chatId AND m.isDeleted = false")
    Long countNonDeletedByChatId(@Param("chatId") UUID chatId);

    @Query("SELECT COUNT(m) FROM Message m WHERE m.temporaryChat.tempChatId = :tempChatId AND m.isDeleted = false")
    Long countNonDeletedByTempChatId(@Param("tempChatId") UUID tempChatId);

    @Query("SELECT m FROM Message m " +
            "LEFT JOIN FETCH m.gift " +
            "LEFT JOIN FETCH m.media " +
            "LEFT JOIN FETCH m.contentType " +
            "WHERE m.chat.chatId = :chatId AND m.isDeleted = false " +
            "ORDER BY m.createdAt ASC")
    List<Message> findNonDeletedMessagesWithGiftByChatId(@Param("chatId") UUID chatId);

    @Query("SELECT m FROM Message m " +
            "LEFT JOIN FETCH m.gift " +
            "LEFT JOIN FETCH m.media " +
            "LEFT JOIN FETCH m.contentType " +
            "WHERE m.temporaryChat.tempChatId = :tempChatId AND m.isDeleted = false " +
            "ORDER BY m.createdAt ASC")
    List<Message> findNonDeletedMessagesWithGiftByTempChatId(@Param("tempChatId") UUID tempChatId);

    @Query("SELECT m FROM Message m " +
            "LEFT JOIN FETCH m.gift " +
            "WHERE m.chat.chatId = :chatId " +
            "ORDER BY m.createdAt DESC")
    Page<Message> findMessagesWithGiftByChatId(@Param("chatId") UUID chatId, Pageable pageable);

    @Query("SELECT m FROM Message m " +
            "LEFT JOIN FETCH m.gift " +
            "WHERE m.temporaryChat.tempChatId = :tempChatId " +
            "ORDER BY m.createdAt DESC")
    Page<Message> findMessagesWithGiftByTempChatId(@Param("tempChatId") UUID tempChatId, Pageable pageable);

}
