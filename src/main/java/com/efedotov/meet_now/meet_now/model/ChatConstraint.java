package com.efedotov.meet_now.meet_now.model;

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
@Table(name = "chat_constraints")
public class ChatConstraint {
    @Id
    @GeneratedValue
    private UUID id;

    @OneToOne
    @JoinColumn(name = "temp_chat_id")
    private TemporaryChat temporaryChat;

    @Column(name = "wait_seconds")
    private Integer waitSeconds = 30;

    @Column(name = "can_start")
    private Boolean canStart = false;
}
