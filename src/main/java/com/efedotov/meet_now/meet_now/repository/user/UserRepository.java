package com.efedotov.meet_now.meet_now.repository.user;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
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

        @Query(value = "SELECT COUNT(*) FROM friendships", nativeQuery = true)
        long countTotalFriendships();

        @Query("SELECT COUNT(DISTINCT f.user.id) FROM Friendship f")
        long countUsersWithFriends();

        @Query(value = "SELECT AVG(friend_count) FROM (" +
                        "SELECT user_id, COUNT(friend_id) as friend_count FROM friendships GROUP BY user_id" +
                        ") as counts", nativeQuery = true)
        Double getAverageFriendsPerUser();

        @Query(value = "SELECT MAX(friend_count) FROM (" +
                        "SELECT user_id, COUNT(friend_id) as friend_count FROM friendships GROUP BY user_id" +
                        ") as counts", nativeQuery = true)
        Integer getMaxFriendsCount();

        @Query(value = "SELECT COUNT(*) FROM (" +
                        "SELECT user_id FROM friendships GROUP BY user_id HAVING COUNT(friend_id) BETWEEN :min AND :max"
                        +
                        ") as users_in_range", nativeQuery = true)
        long countUsersWithFriendsBetween(@Param("min") int min, @Param("max") int max);

        @Query(value = "SELECT COUNT(*) FROM (" +
                        "SELECT user_id FROM friendships GROUP BY user_id HAVING COUNT(friend_id) > :min" +
                        ") as users_more_than", nativeQuery = true)
        long countUsersWithFriendsMoreThan(@Param("min") int min);

        @EntityGraph(attributePaths = { "friends" })
        @Query("SELECT u FROM User u WHERE u.id = :userId")
        Optional<User> findByIdWithFriends(@Param("userId") UUID userId);

        @Query(value = "SELECT u, COUNT(f.id) as friendCount FROM User u LEFT JOIN Friendship f ON u.id = f.user.id GROUP BY u.id ORDER BY friendCount DESC")
        List<Object[]> findPopularUsersWithFriendCount(@Param("limit") int limit);

        List<User> findByEncryptedPushTokenIsNotNull();

        List<User> findByIsOnlineTrueAndEncryptedPushTokenIsNotNull();

        @Query("SELECT COUNT(u) FROM User u WHERE u.encryptedPushToken IS NOT NULL")
        long countUsersWithPushTokens();

        @Query(value = """
                            SELECT u.*
                            FROM users u
                            WHERE u.id <> :currentUserId
                              AND u.is_online = true
                              AND u.is_searchable = true
                              AND u.is_searching = true
                              AND (:floor IS NULL OR u.floor = :floor)
                              AND (:verified IS NULL OR u.verified = :verified)
                              AND (:city IS NULL OR u.city = :city)
                              AND (:ageStart IS NULL OR u.age >= :ageStart)
                              AND (:ageStop IS NULL OR u.age <= :ageStop)
                              AND (
                                    :interestsEmpty = true OR EXISTS (
                                        SELECT 1 FROM user_interests ui
                                        WHERE ui.user_id = u.id AND ui.interest IN (:interests)
                                    )
                                  )
                              AND (
                                    :purposesEmpty = true OR EXISTS (
                                        SELECT 1 FROM user_purposes up
                                        WHERE up.user_id = u.id AND up.purpose IN (:purposes)
                                    )
                                  )
                            ORDER BY RANDOM()
                            LIMIT 1
                        """, nativeQuery = true)
        Optional<User> findRandomUserForSearch(
                        @Param("currentUserId") UUID currentUserId,
                        @Param("floor") String floor,
                        @Param("verified") Boolean verified,
                        @Param("city") String city,
                        @Param("ageStart") Integer ageStart,
                        @Param("ageStop") Integer ageStop,
                        @Param("interests") List<String> interests,
                        @Param("purposes") List<String> purposes,
                        @Param("interestsEmpty") boolean interestsEmpty,
                        @Param("purposesEmpty") boolean purposesEmpty);

}