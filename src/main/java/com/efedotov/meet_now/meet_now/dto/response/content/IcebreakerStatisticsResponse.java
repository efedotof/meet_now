package com.efedotov.meet_now.meet_now.dto.response.content;

import java.util.List;

import com.efedotov.meet_now.meet_now.model.content.IcebreakerTopec;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class IcebreakerStatisticsResponse {
    private Long totalTopics;
    private Long topicsWithText;
    private Long topicsWithLongText;
    private Long topicsWithShortText;
    private List<IcebreakerTopec> longestTopics;
}