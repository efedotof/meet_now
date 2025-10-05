package com.efedotov.meet_now.meet_now.dto.request.social;

import java.util.UUID;

import lombok.Data;

@Data
public class FriendRequest {
    private UUID fromUserId;
    private UUID toUserId;
}
