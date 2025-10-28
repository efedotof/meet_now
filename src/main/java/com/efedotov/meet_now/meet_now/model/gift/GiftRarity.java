package com.efedotov.meet_now.meet_now.model.gift;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "gift_rarities")
public class GiftRarity {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    @Column(name = "display_name", nullable = false, length = 100)
    private String displayName;

    @Column(nullable = false, length = 7)
    private String color;

    @Builder.Default
    @Column
    private Double multiplier = 1.00;

    @Builder.Default
    @Column
    private Double probability = 1.00;

    @Builder.Default
    @Column(name = "min_points")
    private Integer minPoints = 0;

    @Builder.Default
    @Column(name = "max_points")
    private Integer maxPoints = 100;

    @Builder.Default
    @Column(name = "is_active")
    private Boolean isActive = true;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}