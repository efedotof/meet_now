package com.efedotov.meet_now.meet_now.dto.request.gift;

import lombok.Data;

import java.util.UUID;

@Data
public class SendGiftRequest {
    private UUID recipientId;
    private UUID giftId;
    private UUID chatId;
    private UUID tempChatId;
    private String message;
    private Boolean isAnonymous = false;
}