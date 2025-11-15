package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.Data;
import java.util.UUID;

@Data
public class FriendRequestDto {
    private UUID fromUserId;
    private String fromUsername;
    private UUID toUserId;
    private String toUsername;
}