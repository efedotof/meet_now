package com.efedotov.meet_now.meet_now.dto;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.Data;

@Data
public class ReportDto {
    private UUID id;
    private UUID reporterId;
    private UUID reportedId;
    private String reason;
    private LocalDateTime createdAt;
}
