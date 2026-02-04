package com.efedotov.meet_now.meet_now.dto.response.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class AgreeChatResponseDto {
    private UUID tempChatId;
    private UUID userId;
    private Boolean senderAgreed;
    private Boolean recipientAgreed;
    private Boolean bothAgreed;
    private Boolean permanentChatCreated = false;
    private Boolean success;
    private String errorMessage;
    private PermanentChatResponseDto permanentChat;
}