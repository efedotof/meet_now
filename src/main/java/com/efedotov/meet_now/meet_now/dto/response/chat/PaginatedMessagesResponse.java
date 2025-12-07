package com.efedotov.meet_now.meet_now.dto.response.chat;

import lombok.Data;
import java.util.List;

@Data
public class PaginatedMessagesResponse {
    private List<MessageDto> messages;
    private int currentPage;
    private int totalPages;
    private int totalMessages;
    private boolean hasNext;
}