package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.Data;

@Data
public class FriendStatisticsDto {
    private long totalUsers;
    private long totalFriendships;
    private double averageFriendsPerUser;
    private long usersWithNoFriends;
    private int mostFriendsCount;
    private long friendRequestsCount;
    private FriendsDistributionDto friendsDistribution;
}