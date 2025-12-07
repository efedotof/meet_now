package com.efedotov.meet_now.meet_now.repository.chat;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.chat.Chat;

@Repository
public interface ChatRepository extends JpaRepository<Chat, UUID> {
        List<Chat> findByUser1IdOrUser2Id(UUID user1Id, UUID user2Id);

        Optional<Chat> findByUser1IdAndUser2Id(UUID user1Id, UUID user2Id);

        List<Chat> findByIsOpened(Boolean isOpened);

        @Query("SELECT CASE WHEN COUNT(c) > 0 THEN true ELSE false END " +
                        "FROM Chat c " +
                        "WHERE c.chatId = :chatId " +
                        "AND (c.user1.id = :userId OR c.user2.id = :userId)")
        boolean existsByChatIdAndUserId(@Param("chatId") UUID chatId, @Param("userId") UUID userId);

        @Query("SELECT c FROM Chat c WHERE (c.user1.id = :userId AND c.deletedByUser1 = false) OR (c.user2.id = :userId AND c.deletedByUser2 = false)")
        List<Chat> findNonDeletedChatsByUserId(@Param("userId") UUID userId);

        @Query("SELECT c FROM Chat c WHERE (c.user1.id = :userId AND c.deletedByUser1 = true) OR (c.user2.id = :userId AND c.deletedByUser2 = true)")
        List<Chat> findDeletedChatsByUserId(@Param("userId") UUID userId);

        long countByIsOpened(Boolean isOpened);

        long countByIsOpenedTrue();

        long countByDeletedByUser1TrueOrDeletedByUser2True();

        @Query("SELECT c FROM Chat c WHERE " +
                        "(c.user1.id = :user1Id AND c.user2.id = :user2Id) OR " +
                        "(c.user1.id = :user2Id AND c.user2.id = :user1Id)")
        Optional<Chat> findChatByTwoUsers(@Param("user1Id") UUID user1Id,
                        @Param("user2Id") UUID user2Id);

        @Query("SELECT c FROM Chat c WHERE " +
                        "((c.user1.id = :user1Id AND c.user2.id = :user2Id) OR " +
                        "(c.user1.id = :user2Id AND c.user2.id = :user1Id)) AND " +
                        "((c.user1.id = :userId AND c.deletedByUser1 = false) OR " +
                        "(c.user2.id = :userId AND c.deletedByUser2 = false))")
        Optional<Chat> findNonDeletedChatByTwoUsers(@Param("user1Id") UUID user1Id,
                        @Param("user2Id") UUID user2Id,
                        @Param("userId") UUID userId);
}