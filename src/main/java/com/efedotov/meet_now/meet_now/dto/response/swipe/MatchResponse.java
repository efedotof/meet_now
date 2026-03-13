package com.efedotov.meet_now.meet_now.dto.response.swipe;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MatchResponse {
    private UUID matchId;
    private UUID userId;
    private String username;
    private String firstname;
    private String subname;
    private String avatar;
    private LocalDateTime matchedAt;
}