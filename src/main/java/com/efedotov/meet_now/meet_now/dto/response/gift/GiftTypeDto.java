package com.efedotov.meet_now.meet_now.dto.response.gift;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class GiftTypeDto {
    private UUID id;
    private String typeName;
    private String description;
}