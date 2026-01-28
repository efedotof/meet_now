package com.efedotov.meet_now.meet_now.dto.request.search;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchRequest {
    private UUID userId;
    private SearchFilters filters;
    private LocalDateTime addedAt;
}
