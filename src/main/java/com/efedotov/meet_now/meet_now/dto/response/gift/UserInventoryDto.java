package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class UserInventoryDto {
    private UUID id;
    private GiftDto gift;
    private UUID receivedFromId;
    private Integer quantity;
    private Boolean isVisible;
    private LocalDateTime receivedAt;
}