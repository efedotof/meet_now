package com.efedotov.meet_now.meet_now.dto.request.search;

import lombok.Data;
import java.util.List;

@Data
public class SearchRequestDto {
    private String floor;
    private Integer ageFrom;
    private Integer ageTo;
    private List<String> interests;
    private List<String> purposes;
    private Boolean onlyVerified;
    private String city;
}