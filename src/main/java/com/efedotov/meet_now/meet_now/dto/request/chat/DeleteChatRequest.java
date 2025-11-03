package com.efedotov.meet_now.meet_now.dto.request.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class DeleteChatRequest {
    private UUID chatId;
    private UUID userId;
    private boolean deleteForBoth = false;
}