package com.efedotov.meet_now.meet_now.dto.request.search;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchFilters {
    private List<String> interests;
    private List<String> purposes;
    private Boolean verified;
    private Integer ageStart;
    private Integer ageStop;
    private String city;
    private String floor;
}
