package com.efedotov.meet_now.meet_now.model;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
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

    private String city;

    private Integer age;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    private Boolean verified = false;

    @Column(name = "is_searchable")
    private Boolean isSearchable = true;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "user_friends", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "friend_id"))
    private Set<User> friends;

    @ElementCollection(fetch = FetchType.LAZY)
    @JoinTable(name = "user_purposes", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "purpose")
    private List<String> purposes;

    @ElementCollection(fetch = FetchType.LAZY)
    @JoinTable(name = "user_interests", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "interest")
    private List<String> interests;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "user_roles", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles;

    @Column(name = "is_online")
    private Boolean isOnline = false;

}
