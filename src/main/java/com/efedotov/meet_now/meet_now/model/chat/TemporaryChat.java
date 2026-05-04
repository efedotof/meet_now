package com.efedotov.meet_now.meet_now.model.chat;

import java.time.LocalDateTime;
import java.util.UUID;

import com.efedotov.meet_now.meet_now.model.user.User;

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
@Table(name = "temporary_chats")
public class TemporaryChat {
    @Id
    @GeneratedValue
    @Column(name = "temp_chat_id")
    private UUID tempChatId;

    @ManyToOne
    @JoinColumn(name = "sender_id")
    private User sender;

    @ManyToOne
    @JoinColumn(name = "recipient_id")
    private User recipient;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "duration_minutes")
    private Integer durationMinutes = 5;

    @Column(name = "is_finished")
    private Boolean isFinished = false;

    @Column(name = "sender_agreed")
    private Boolean senderAgreed = false;

    @Column(name = "recipient_agreed")
    private Boolean recipientAgreed = false;

    @Column(name = "both_agreed")
    private Boolean bothAgreed = false;

    @Column(name = "deleted_by_sender")
    private Boolean deletedBySender = false;

    @Column(name = "deleted_by_recipient")
    private Boolean deletedByRecipient = false;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "encrypted_aes_key_sender", columnDefinition = "TEXT")
    private String encryptedAesKeyForSender;

    @Column(name = "encrypted_aes_key_recipient", columnDefinition = "TEXT")
    private String encryptedAesKeyForRecipient;
}