package com.efedotov.meet_now.meet_now.dto.response.chat;

import lombok.Data;
import java.util.List;
import java.util.UUID;

import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;

@Data
public class UserChatsResponse {
    private UUID userId;
    private List<Chat> permanentChats;
    private List<TemporaryChat> temporaryChats;
    private int totalPermanentChats;
    private int totalTemporaryChats;
}
