package com.efedotov.meet_now.meet_now.repository.notification;

import com.efedotov.meet_now.meet_now.model.notification.NotificationHistory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface NotificationHistoryRepository extends JpaRepository<NotificationHistory, UUID> {

    Page<NotificationHistory> findByUserId(UUID userId, Pageable pageable);

    Page<NotificationHistory> findByNotificationType(String notificationType, Pageable pageable);

    Page<NotificationHistory> findBySuccess(boolean success, Pageable pageable);

    long countBySuccess(boolean success);

    @Query("SELECT nh.notificationType, COUNT(nh) FROM NotificationHistory nh GROUP BY nh.notificationType")
    List<Object[]> countByNotificationType();

    @Modifying
    @Query("DELETE FROM NotificationHistory nh WHERE nh.sentAt < :cutoffDate")
    int deleteBySentAtBefore(@Param("cutoffDate") LocalDateTime cutoffDate);
}