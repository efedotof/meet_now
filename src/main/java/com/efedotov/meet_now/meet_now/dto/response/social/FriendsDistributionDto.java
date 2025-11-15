package com.efedotov.meet_now.meet_now.dto.response.social;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FriendsDistributionDto {
    private Long zeroFriends;
    private Long oneToFiveFriends;
    private Long sixToTenFriends;
    private Long elevenToTwentyFriends;
    private Long twentyOnePlusFriends;
}