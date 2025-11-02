package com.efedotov.meet_now.meet_now.dto.response.chat;

import lombok.Data;
import java.util.UUID;

@Data
public class ChatFinishedDto {
    private UUID tempChatId;
    private boolean finished;
}