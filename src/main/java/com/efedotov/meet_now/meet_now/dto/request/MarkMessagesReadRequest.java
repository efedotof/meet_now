package com.efedotov.meet_now.meet_now.dto.request;

import java.util.List;
import java.util.UUID;

import lombok.Data;

@Data
public class MarkMessagesReadRequest {
    private List<UUID> messageIds;
}
