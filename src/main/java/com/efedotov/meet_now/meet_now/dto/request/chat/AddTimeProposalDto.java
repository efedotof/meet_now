package com.efedotov.meet_now.meet_now.dto.request.chat;

import java.util.UUID;

import lombok.Data;

@Data
public class AddTimeProposalDto {
    private UUID tempChatId;
    private UUID fromUserId;
    private int additionalMinutes;
}
