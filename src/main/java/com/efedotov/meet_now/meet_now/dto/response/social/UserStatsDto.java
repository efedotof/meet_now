package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserStatsDto {
    private long onlineCount;
    private long searchingCount;
}
