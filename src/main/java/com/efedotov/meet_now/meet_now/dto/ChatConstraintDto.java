package com.efedotov.meet_now.meet_now.dto;

import java.util.UUID;
import lombok.Data;

@Data
public class ChatConstraintDto {
    private UUID id;
    private UUID temporaryChatId;
    private Integer waitSeconds;
    private Boolean canStart;
}
