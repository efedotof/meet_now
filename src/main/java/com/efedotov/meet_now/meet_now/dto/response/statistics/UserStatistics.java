package com.efedotov.meet_now.meet_now.dto.response.statistics;

import lombok.Builder;
import lombok.Data;
import java.util.List;

import com.efedotov.meet_now.meet_now.dto.response.city.CityCountDTO;
import com.efedotov.meet_now.meet_now.dto.response.social.AgeGroupStatisticDto;

@Data
@Builder
public class UserStatistics {
    private long totalUsers;
    private long onlineUsers;
    private long searchingUsers;
    private long searchableUsers;
    private long newUsersLast24h;
    private long newUsersLast7d;
    private long verifiedUsers;
    private long blockedUsers;
    private List<CityCountDTO> usersByCity;
    private List<AgeGroupStatisticDto> usersByAgeGroup;
}