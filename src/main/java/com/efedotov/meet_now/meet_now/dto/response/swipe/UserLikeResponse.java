package com.efedotov.meet_now.meet_now.dto.response.swipe;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserLikeResponse {
    private UUID id;
    private String username;
    private String firstname;
    private String subname;
    private String avatar;
    private Integer age;
    private String city;
    private Set<String> roles;
    private String floor;
    private Boolean verified;
}