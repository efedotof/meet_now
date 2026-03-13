package com.efedotov.meet_now.meet_now.dto.response.swipe;

import java.util.List;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SwipeCandidateResponse {
    private UUID id;
    private String username;
    private String firstname;
    private String subname;
    private Integer age;
    private String city;
    private String avatar;
    private List<String> images;
    private List<String> purposes;
    private List<String> interests;
    private String description;
    private Boolean verified;
}