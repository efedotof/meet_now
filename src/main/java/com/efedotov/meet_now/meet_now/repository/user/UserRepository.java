package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
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

    List<User> findByIsSearchingTrue();

    @Override
    @NonNull
    Page<User> findAll(@Nullable Specification<User> spec, @NonNull Pageable pageable);

    @Modifying
    @Query("UPDATE User u SET u.isSearching = :searching, u.isSearchable = :searchable WHERE u.id = :userId")
    int setUserSearchingStatus(@Param("userId") UUID userId,
            @Param("searchable") Boolean searchable,
            @Param("searching") Boolean searching);

    @Query("SELECT u FROM User u WHERE u.isOnline = true AND u.isSearchable = true AND u.isSearching = true AND u.id != :excludeId")
    List<User> findAvailableUsers(@Param("excludeId") UUID excludeId, Pageable pageable);

    @Query("SELECT COUNT(u) FROM User u WHERE u.isOnline = true AND u.isSearchable = true AND u.isSearching = true")
    long countAvailableForSearchUsers();

}