package com.efedotov.meet_now.meet_now.model.gift;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import com.efedotov.meet_now.meet_now.model.user.User;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "daily_gifts")
public class DailyGift {
    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "gift_id", nullable = false)
    private Gift gift;

    @CreationTimestamp
    @Column(name = "received_at")
    private LocalDateTime receivedAt;

    @Builder.Default
    @Column(name = "streak_count")
    private Integer streakCount = 1;
}