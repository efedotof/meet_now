package com.efedotov.meet_now.meet_now.dto.request.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class DeleteMessageRequest {
    private UUID messageId;
    private UUID userId;
    private boolean deleteForEveryone = false;
}