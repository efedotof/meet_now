package com.efedotov.meet_now.meet_now.dto.response.moderation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserQuestionStatisticDto {
    private UUID userId;
    private Long questionCount;
}