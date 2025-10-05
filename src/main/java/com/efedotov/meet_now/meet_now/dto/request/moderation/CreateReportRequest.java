
package com.efedotov.meet_now.meet_now.dto.request.moderation;

import java.util.UUID;

import lombok.Data;

@Data
public class CreateReportRequest {
    private UUID reporterId;
    private UUID reportedId;
    private String reason;
}