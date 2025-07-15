package com.efedotov.meet_now.meet_now.model;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "chats")
public class Chat {
    @Id
    @GeneratedValue
    @Column(name = "chat_id")
    private UUID chatId;

    @ManyToOne
    @JoinColumn(name = "user_id1", nullable = false)
    private User user1;

    @ManyToOne
    @JoinColumn(name = "user_id2", nullable = false)
    private User user2;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "is_opened")
    private Boolean isOpened = false;

    @Column(name = "last_message", columnDefinition = "TEXT")
    private String lastMessage;


}
