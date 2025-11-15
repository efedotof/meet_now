package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class UserWithFriendCountDto {
    private UUID userId;
    private String username;
    private String email;
    private int friendCount;
    private LocalDateTime createdAt;
}