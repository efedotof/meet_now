package com.efedotov.meet_now.meet_now.dto.response.city;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CityCountDTO {
    private String city;
    private Long userCount;
}