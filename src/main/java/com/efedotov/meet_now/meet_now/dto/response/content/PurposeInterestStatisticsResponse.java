package com.efedotov.meet_now.meet_now.dto.response.content;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class PurposeInterestStatisticsResponse {
    private Long totalInterests;
    private Long totalPurposes;
    private List<String> popularInterests;
    private List<String> popularPurposes;
}