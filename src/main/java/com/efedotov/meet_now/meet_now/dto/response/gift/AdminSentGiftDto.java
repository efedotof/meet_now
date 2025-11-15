package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class AdminSentGiftDto {
    private UUID id;
    private UUID senderId;
    private String senderUsername;
    private UUID recipientId;
    private String recipientUsername;
    private AdminGiftDto gift;
    private UUID chatId;
    private UUID tempChatId;
    private String message;
    private Boolean isAnonymous;
    private LocalDateTime sentAt;
}