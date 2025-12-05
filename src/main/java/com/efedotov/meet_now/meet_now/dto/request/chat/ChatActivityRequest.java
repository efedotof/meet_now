package com.efedotov.meet_now.meet_now.dto.request.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class ChatActivityRequest {
    private UUID chatId;
    private UUID tempChatId;

    public UUID getChatId() {
        if (chatId != null) {
            return chatId;
        }
        return tempChatId;
    }
}