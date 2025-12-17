package com.efedotov.meet_now.meet_now.model.notification;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Entity
@Table(name = "notification_history")
public class NotificationHistory {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "title")
    private String title;

    @Column(name = "message", columnDefinition = "TEXT")
    private String message;

    @Column(name = "notification_type")
    private String notificationType; // "token", "user", "multicast", "data"

    @Column(name = "sent_at")
    private LocalDateTime sentAt;

    @Column(name = "success")
    private boolean success;

    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;

    @PrePersist
    protected void onCreate() {
        sentAt = LocalDateTime.now();
    }
}