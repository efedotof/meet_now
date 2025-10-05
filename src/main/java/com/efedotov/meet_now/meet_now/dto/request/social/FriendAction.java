package com.efedotov.meet_now.meet_now.dto.request.social;

import java.util.UUID;

import lombok.Data;

@Data
public class FriendAction {
    private UUID currentUserId;
    private UUID requesterId;
}
