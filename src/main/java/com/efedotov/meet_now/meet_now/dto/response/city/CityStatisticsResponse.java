package com.efedotov.meet_now.meet_now.dto.response.city;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class CityStatisticsResponse {
    private Long totalCities;
    private Long citiesWithUsers;
    private Long citiesWithoutUsers;
    private List<CityCountDTO> popularCities;
    private List<CityCountDTO> citiesUsage;
}