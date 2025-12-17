package com.efedotov.meet_now.meet_now.dto.response.notification;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class UserTokenStatusDto {
    private UUID userId;
    private String username;
    private String email;
    private boolean hasPushToken;
    private boolean isOnline;
    private LocalDateTime tokenRegisteredAt;
    private LocalDateTime lastSeen;
}