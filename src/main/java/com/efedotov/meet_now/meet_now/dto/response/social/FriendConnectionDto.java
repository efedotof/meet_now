package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class FriendConnectionDto {
    private UUID user1Id;
    private String user1Username;
    private UUID user2Id;
    private String user2Username;
    private LocalDateTime friendsSince;
}