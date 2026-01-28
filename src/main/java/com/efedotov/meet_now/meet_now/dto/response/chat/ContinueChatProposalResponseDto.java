package com.efedotov.meet_now.meet_now.dto.response.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class ContinueChatProposalResponseDto {
    private UUID tempChatId;
    private UUID fromUserId;
    private UUID toUserId;
    private String message;
    private Long timestamp;
}