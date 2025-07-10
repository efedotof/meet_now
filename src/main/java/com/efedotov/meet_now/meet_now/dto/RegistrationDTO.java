package com.efedotov.meet_now.meet_now.dto;

import java.util.List;

import lombok.Data;

@Data
public class RegistrationDTO {
    private String username;
    private String email;
    private String firstname;
    private String subname;
    private String description;
    private String avatar;
    private String city;
    private Integer age;
    private List<String> purposes;
    private List<String> interests;
    private Boolean isSearchable;
    private String password;
}
