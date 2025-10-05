package com.efedotov.meet_now.meet_now.dto.response.moderation;

import java.time.LocalDateTime;
import java.util.UUID;

import com.efedotov.meet_now.meet_now.model.moderation.ReportStatus;

import lombok.Data;

@Data
public class ReportDto {
    private UUID id;
    private UUID reporterId;
    private UUID reportedId;
    private String reason;
    private ReportStatus status;
    private LocalDateTime createdAt;
}