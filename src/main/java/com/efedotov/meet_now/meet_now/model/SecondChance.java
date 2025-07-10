package com.efedotov.meet_now.meet_now.model;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "second_chance")
public class SecondChance {
    @Id
    @GeneratedValue
    private UUID id;

    @OneToOne
    @JoinColumn(name = "temp_chat_id")
    private TemporaryChat temporaryChat;

    @Column(name = "sender_decision")
    private Boolean senderDecision;

    @Column(name = "recipient_decision")
    private Boolean recipientDecision;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    private Boolean processed = false;
}
