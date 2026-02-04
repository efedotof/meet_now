package com.efedotov.meet_now.meet_now.dto.request.search;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TemporaryChatAckRequest {
    private UUID userId;
}