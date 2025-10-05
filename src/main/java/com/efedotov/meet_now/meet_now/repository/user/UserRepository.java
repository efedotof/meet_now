package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.user.User;

@Repository
public interface UserRepository extends JpaRepository<User, UUID>, JpaSpecificationExecutor<User> {
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    List<User> findByIsSearchableTrue();

    List<User> findByIsSearchableTrueAndIsOnlineTrue();

    List<User> findByCity(String city);

    List<User> findByIsOnlineTrue();

    long countByIsOnlineTrue();
    long countByIsSearchableTrue();
    long countByIsSearchingTrue();
}