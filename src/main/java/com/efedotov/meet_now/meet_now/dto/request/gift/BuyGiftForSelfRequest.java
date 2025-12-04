package com.efedotov.meet_now.meet_now.dto.request.gift;

import java.util.UUID;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BuyGiftForSelfRequest {
    @NotNull(message = "ID подарка не может быть пустым")
    private UUID giftId;
}