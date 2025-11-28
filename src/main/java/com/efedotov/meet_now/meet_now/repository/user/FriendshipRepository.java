package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.efedotov.meet_now.meet_now.model.user.Friendship;

public interface FriendshipRepository extends JpaRepository<Friendship, UUID> {

    Optional<Friendship> findByUserIdAndFriendId(UUID userId, UUID friendId);

    List<Friendship> findByUserId(UUID userId);

    List<Friendship> findByFriendId(UUID friendId);

    boolean existsByUserIdAndFriendId(UUID userId, UUID friendId);

    void deleteByUserIdAndFriendId(UUID userId, UUID friendId);

    @Query("SELECT COUNT(f) FROM Friendship f WHERE f.user.id = :userId")
    long countByUserId(@Param("userId") UUID userId);

    @Query(value = "SELECT AVG(friend_count) FROM (" +
            "SELECT user_id, COUNT(friend_id) as friend_count FROM friendships GROUP BY user_id" +
            ") as counts", nativeQuery = true)
    Double getAverageFriendsPerUser();

    @Query(value = "SELECT MAX(friend_count) FROM (" +
            "SELECT user_id, COUNT(friend_id) as friend_count FROM friendships GROUP BY user_id" +
            ") as counts", nativeQuery = true)
    Integer getMaxFriendsCount();
}