package com.efedotov.meet_now.meet_now.dto.response.chat;

import lombok.Data;

@Data
public class ChatStatisticsAdmin {
    private long totalPermanentChats;
    private long totalTemporaryChats;
    private long activeTemporaryChats;
    private long activePermanentChats;
    private long deletedPermanentChats;
}

