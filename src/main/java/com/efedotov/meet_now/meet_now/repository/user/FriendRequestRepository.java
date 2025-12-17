package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.efedotov.meet_now.meet_now.model.user.FriendRequest;
import com.efedotov.meet_now.meet_now.model.user.FriendRequestStatus;

public interface FriendRequestRepository extends JpaRepository<FriendRequest, UUID> {

        Optional<FriendRequest> findByFromUserIdAndToUserIdAndStatus(
                        UUID fromUserId, UUID toUserId, FriendRequestStatus status);

        List<FriendRequest> findByToUserIdAndStatus(UUID toUserId, FriendRequestStatus status);

        List<FriendRequest> findByFromUserIdAndStatus(UUID fromUserId, FriendRequestStatus status);

        boolean existsByFromUserIdAndToUserIdAndStatus(
                        UUID fromUserId, UUID toUserId, FriendRequestStatus status);

        @Query("SELECT COUNT(fr) FROM FriendRequest fr WHERE fr.status = 'PENDING'")
        long countPendingRequests();

        List<FriendRequest> findByStatus(FriendRequestStatus status);

        @Modifying
        @Query("DELETE FROM FriendRequest fr WHERE fr.fromUser.id = :fromUserId OR fr.toUser.id = :toUserId")
        void deleteByFromUserIdOrToUserId(@Param("fromUserId") UUID fromUserId, @Param("toUserId") UUID toUserId);
}
