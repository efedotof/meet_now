package com.efedotov.meet_now.meet_now.model.search;

import lombok.*;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "match_delivery_state")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MatchDeliveryState {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id")
    private UUID id;

    @Column(name = "chat_id", nullable = false)
    private UUID chatId;

    @Column(name = "user1_id", nullable = false)
    private UUID user1Id;

    @Column(name = "user2_id", nullable = false)
    private UUID user2Id;

    @Column(name = "user1_received", nullable = false)
    @Builder.Default
    private boolean user1Received = false;

    @Column(name = "user2_received", nullable = false)
    @Builder.Default
    private boolean user2Received = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Builder.Default
    private MatchDeliveryStatus status = MatchDeliveryStatus.PENDING;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "user1_acknowledged_at")
    private LocalDateTime user1AcknowledgedAt;

    @Column(name = "user2_acknowledged_at")
    private LocalDateTime user2AcknowledgedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}