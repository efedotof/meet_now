package com.efedotov.meet_now.meet_now.dto.request.moderation;

import com.efedotov.meet_now.meet_now.model.moderation.ReportStatus;

import lombok.Data;

@Data
public class UpdateReportStatusRequest {
    private ReportStatus status;
}