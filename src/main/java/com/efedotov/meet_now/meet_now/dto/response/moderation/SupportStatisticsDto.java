package com.efedotov.meet_now.meet_now.dto.response.moderation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SupportStatisticsDto {
    private Long totalQuestions;
    private Long totalAnswers;
    private Long pendingQuestions;
    private Long resolvedQuestions;
    private Long unansweredQuestions;
    private Double averageResponseTimeHours;
    private List<UserQuestionStatisticDto> mostActiveUsers;
    private List<DailyQuestionStatisticDto> questionsLast7Days;
}