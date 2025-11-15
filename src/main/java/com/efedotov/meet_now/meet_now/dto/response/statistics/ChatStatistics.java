package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Data;

@Data
public class ChatStatistics {
    private long totalChats;
    private long activeChats;
    private long temporaryChats;
    private long finishedTemporaryChats;
    private long totalMessages;
    private long unreadMessages;
    private double avgMessagesPerChat;
}
