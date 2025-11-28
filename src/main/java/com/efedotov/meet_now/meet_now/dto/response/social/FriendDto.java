package com.efedotov.meet_now.meet_now.dto.response.social;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import lombok.Data;

@Data
public class FriendDto {
    private UUID id;
    private String username;
    private String email;
    private String firstname;
    private String subname;
    private String description;
    private String avatar;
    private String city;
    private Integer age;
    private LocalDateTime createdAt;
    private Boolean verified;
    private Boolean isOnline;
    private String floor;
    private int gamePoints;
    private List<String> images;
}