package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;
import java.util.UUID;
import java.time.LocalDateTime;

@Data
@Builder
public class BuyGiftResponse {
    private UUID purchaseId;
    private UserInventoryDto inventoryItem;
    private Integer spentPoints;
    private Integer newBalance;
    private LocalDateTime purchasedAt;
}