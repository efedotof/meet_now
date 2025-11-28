package com.efedotov.meet_now.meet_now.model.user;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.Set;
import java.util.UUID;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
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

    @OneToMany(mappedBy = "fromUser", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<FriendRequest> sentFriendRequests = new ArrayList<>();

    @OneToMany(mappedBy = "toUser", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<FriendRequest> receivedFriendRequests = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Friendship> friendships = new ArrayList<>();

    @ElementCollection(fetch = FetchType.LAZY)
    @JoinTable(name = "user_purposes", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "purpose")
    private List<String> purposes = Collections.synchronizedList(new ArrayList<>());

    @ElementCollection(fetch = FetchType.LAZY)
    @JoinTable(name = "user_interests", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "interest")
    private List<String> interests = Collections.synchronizedList(new ArrayList<>());

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "user_roles", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles;

    @Column(name = "is_online")
    private Boolean isOnline = false;

    @Column(name = "floor")
    private String floor;

    @Column(name = "is_searching")
    private Boolean isSearching = false;

    @Column(name = "game_points")
    private int gamePoints = 0;

    @ElementCollection(fetch = FetchType.LAZY)
    @JoinTable(name = "user_images", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "image_url")
    private List<String> images = Collections.synchronizedList(new ArrayList<>());
    @Column(name = "encrypted_push_token")
    private String encryptedPushToken;

    @Column(name = "push_token_salt")
    private String pushTokenSalt;

}
