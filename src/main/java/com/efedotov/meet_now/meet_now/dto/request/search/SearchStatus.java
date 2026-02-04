package com.efedotov.meet_now.meet_now.dto.request.search;

import com.efedotov.meet_now.meet_now.dto.response.chat.TemporaryChatDto;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchStatus {
    private boolean isSearching;
    private LocalDateTime searchingSince;
    private SearchFilters filters;
    private Integer queuePosition;
    private Integer totalInQueue;
    private TemporaryChatDto matchedChat; 
    private String matchStatus;
}