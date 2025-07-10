package com.efedotov.meet_now.meet_now.dto;

import java.time.LocalDate;
import lombok.Data;

@Data
public class QuestionOfDayDto {
    private Long id;
    private String question;
    private LocalDate date;
}
