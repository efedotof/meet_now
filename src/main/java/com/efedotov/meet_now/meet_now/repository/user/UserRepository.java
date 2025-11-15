package com.efedotov.meet_now.meet_now.repository.user;

import java.time.LocalDateTime;
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

import com.efedotov.meet_now.meet_now.dto.response.city.CityCountDTO;
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

        @Query("SELECT COUNT(r) > 0 FROM User u JOIN u.roles r WHERE u.id = :userId AND r.roleName IN ('MODERATION', 'ADMIN')")
        boolean hasModerationRole(@Param("userId") UUID userId);

        long countByCreatedAtAfter(LocalDateTime date);

        Page<User> findByEmailContainingIgnoreCase(String email, Pageable pageable);

        Page<User> findByUsernameContainingIgnoreCase(String username, Pageable pageable);

        @Query("SELECT NEW com.efedotov.meet_now.meet_now.dto.response.city.CityCountDTO(u.city, COUNT(u)) " +
                        "FROM User u WHERE u.city IS NOT NULL AND u.city != '' GROUP BY u.city")
        List<CityCountDTO> countUsersByCity();

        long countByVerifiedTrue();

        long countByRoles_RoleName(String roleName);

        long countByCreatedAtBefore(LocalDateTime date);

        long countByCreatedAtBetween(LocalDateTime start, LocalDateTime end);

        @Query("SELECT COALESCE(SUM(u.gamePoints), 0) FROM User u")
        long sumGamePoints();

        @Query("SELECT COUNT(u) FROM User u WHERE u.city = :cityName")
        long countByCityName(@Param("cityName") String cityName);

        @Query("SELECT COUNT(u) FROM User u JOIN u.interests i WHERE i = :interest")
        long countByInterestsContaining(@Param("interest") String interest);

        @Query("SELECT COUNT(u) FROM User u JOIN u.purposes p WHERE p = :purpose")
        long countByPurpose(@Param("purpose") String purpose);

        @Query("SELECT i, COUNT(u) FROM User u JOIN u.interests i GROUP BY i ORDER BY COUNT(u) DESC")
        List<Object[]> findMostPopularInterests();

        @Query("SELECT p, COUNT(u) FROM User u JOIN u.purposes p GROUP BY p ORDER BY COUNT(u) DESC")
        List<Object[]> findMostPopularPurposes();

        Page<User> findByIsOnlineTrue(Pageable pageable);
}