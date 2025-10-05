package com.efedotov.meet_now.meet_now.dto.request.social;

import java.util.UUID;

import lombok.Data;

@Data
public class RemoveFriendRequest {
    private UUID userId;
    private UUID friendId;
}
