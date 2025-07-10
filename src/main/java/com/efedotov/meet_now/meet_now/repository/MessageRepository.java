package com.efedotov.meet_now.meet_now.repository;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.ChatGame;
import com.efedotov.meet_now.meet_now.model.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, UUID> {
    List<ChatGame> findByChat_ChatId(UUID chatId);
    List<Message> findBySender_Id(UUID senderId);
    List<Message> findByRecipient_Id(UUID recipientId);
    List<Message> findByChat_ChatIdOrderByCreatedAtAsc(UUID chatId);
}
