package com.efedotov.meet_now.meet_now.model;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    private String firstname;
    private String subname;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String avatar;

    @ElementCollection
    @Column(name = "friends")
    private List<UUID> friends;

    private String city;
    private Integer age;

    @ElementCollection
    @Column(name = "purposes")
    private List<String> purposes;

    @ElementCollection
    @Column(name = "interests")
    private List<String> interests;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    private Boolean verified = false;

    @Column(name = "is_searchable")
    private Boolean isSearchable = true;
}
