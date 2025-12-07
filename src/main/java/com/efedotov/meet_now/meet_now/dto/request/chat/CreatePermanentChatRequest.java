package com.efedotov.meet_now.meet_now.dto.request.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class CreatePermanentChatRequest {
    private UUID user1Id;
    private UUID user2Id;
}