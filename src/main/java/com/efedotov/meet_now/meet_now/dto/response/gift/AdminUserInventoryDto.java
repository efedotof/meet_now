package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class AdminUserInventoryDto {
    private UUID id;
    private UUID userId;
    private String username;
    private AdminGiftDto gift;
    private UUID receivedFromId;
    private String receivedFromUsername;
    private Integer quantity;
    private Boolean isVisible;
    private LocalDateTime receivedAt;
}