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
@Table(name = "gifts")
public class Gift {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "gift_type_id", nullable = false)
    private GiftType giftType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rarity_id")
    private GiftRarity rarity;

    @Builder.Default
    @Column(name = "cost_points", nullable = false)
    private Integer costPoints = 0;

    @Builder.Default
    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "animation_url")
    private String animationUrl;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "available_quantity")
    private Integer availableQuantity;

    @Builder.Default
    @Column(name = "is_limited")
    private Boolean isLimited = false;

    @Builder.Default
    @Column(name = "is_sold_out")
    private Boolean isSoldOut = false;

    @Column(name = "initial_quantity")
    private Integer initialQuantity;

    @Builder.Default
    @Column(name = "sold_count")
    private Integer soldCount = 0;

    @Column(name = "current_price")
    private Integer currentPrice;

    @Transient
    public boolean isAvailableForPurchase() {
        if (!isActive) {
            return false;
        }

        if (isLimited) {
            if (isSoldOut) {
                return false;
            }
            if (availableQuantity != null && availableQuantity <= 0) {
                return false;
            }
        }

        return true;
    }

    public boolean decreaseQuantity(int amount) {
        if (isLimited && availableQuantity != null) {
            if (availableQuantity >= amount) {
                availableQuantity -= amount;
                soldCount += amount;

                if (availableQuantity <= 0) {
                    isSoldOut = true;
                }
                return true;
            }
            return false;
        }
        return true;
    }
}