package com.efedotov.meet_now.meet_now.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import lombok.Data;

@Data
public class UserDto {
    private UUID id;
    private String username;
    private String email;
    private String firstname;
    private String subname;
    private String description;
    private String avatar;
    private List<UUID> friends;
    private String city;
    private Integer age;
    private List<String> purposes;
    private List<String> interests;
    private LocalDateTime createdAt;
    private Boolean verified;
    private Boolean isSearchable;
    private String token;
    private Set<String> roles;
    private Boolean isOnline;
}
