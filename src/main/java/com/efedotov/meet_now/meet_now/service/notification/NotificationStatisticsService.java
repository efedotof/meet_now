package com.efedotov.meet_now.meet_now.service.notification;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.response.notification.*;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.repository.notification.NotificationHistoryRepository;
import com.efedotov.meet_now.meet_now.model.notification.NotificationHistory;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationStatisticsService {

    private final UserRepository userRepository;
    private final NotificationHistoryRepository notificationHistoryRepository;

    @AdminOnly
    @Transactional(readOnly = true)
    public NotificationStatisticsDto getNotificationStatistics() {
        long totalUsers = userRepository.count();
        long totalUsersWithTokens = userRepository.countUsersWithPushTokens();
        List<User> onlineUsersWithTokens = userRepository.findByIsOnlineTrueAndEncryptedPushTokenIsNotNull();
        List<User> allUsersWithTokens = userRepository.findByEncryptedPushTokenIsNotNull();

        double percentage = totalUsers > 0 ? (double) totalUsersWithTokens / totalUsers * 100 : 0;

        return NotificationStatisticsDto.builder()
                .totalUsers(totalUsers)
                .totalUsersWithPushTokens(totalUsersWithTokens)
                .onlineUsersWithPushTokens(onlineUsersWithTokens.size())
                .offlineUsersWithPushTokens(totalUsersWithTokens - onlineUsersWithTokens.size())
                .totalRegisteredPushTokens(allUsersWithTokens.size())
                .percentageUsersWithTokens(Math.round(percentage * 100.0) / 100.0)
                .build();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<UserWithTokenDto> getUsersWithPushTokens() {
        List<User> users = userRepository.findByEncryptedPushTokenIsNotNull();

        return users.stream()
                .map(this::mapToUserWithTokenDto)
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<UserWithTokenDto> getOnlineUsersWithPushTokens() {
        List<User> users = userRepository.findByIsOnlineTrueAndEncryptedPushTokenIsNotNull();

        return users.stream()
                .map(this::mapToUserWithTokenDto)
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public UserTokenStatusDto getUserTokenStatus(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));

        boolean hasToken = user.getEncryptedPushToken() != null && !user.getEncryptedPushToken().isEmpty();

        return UserTokenStatusDto.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .hasPushToken(hasToken)
                .tokenRegisteredAt(user.getCreatedAt()) // Можно добавить поле для даты регистрации токена
                .isOnline(user.getIsOnline())
                .lastSeen(LocalDateTime.now()) // Нужно добавить поле lastSeen в User
                .build();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public TokenCoverageDto getTokenCoverageStatistics() {
        long totalUsers = userRepository.count();
        long usersWithTokens = userRepository.countUsersWithPushTokens();
        long onlineUsersWithTokens = userRepository.findByIsOnlineTrueAndEncryptedPushTokenIsNotNull().size();

        double overallCoverage = totalUsers > 0 ? (double) usersWithTokens / totalUsers * 100 : 0;
        double onlineCoverage = onlineUsersWithTokens > 0 ? (double) onlineUsersWithTokens / usersWithTokens * 100 : 0;

        return TokenCoverageDto.builder()
                .totalUsers(totalUsers)
                .usersWithTokens(usersWithTokens)
                .usersWithoutTokens(totalUsers - usersWithTokens)
                .onlineUsersWithTokens(onlineUsersWithTokens)
                .offlineUsersWithTokens(usersWithTokens - onlineUsersWithTokens)
                .overallCoveragePercentage(Math.round(overallCoverage * 100.0) / 100.0)
                .onlineCoveragePercentage(Math.round(onlineCoverage * 100.0) / 100.0)
                .build();
    }

    @AdminOnly
    @Transactional
    public void logNotification(UUID userId, String title, String message,
            String notificationType, boolean success, String errorMessage) {
        NotificationHistory history = new NotificationHistory();
        history.setUserId(userId);
        history.setTitle(title);
        history.setMessage(message);
        history.setNotificationType(notificationType);
        history.setSuccess(success);
        history.setErrorMessage(errorMessage);
        history.setSentAt(LocalDateTime.now());

        notificationHistoryRepository.save(history);
        log.info("Запись уведомления сохранена в историю: userId={}, type={}, success={}",
                userId, notificationType, success);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<NotificationHistoryDto> getNotificationHistory(Pageable pageable) {
        Page<NotificationHistory> historyPage = notificationHistoryRepository.findAll(pageable);

        return historyPage.map(this::mapToNotificationHistoryDto);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<NotificationHistoryDto> getUserNotificationHistory(UUID userId, Pageable pageable) {
        Page<NotificationHistory> historyPage = notificationHistoryRepository.findByUserId(userId, pageable);

        return historyPage.map(this::mapToNotificationHistoryDto);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<NotificationHistoryDto> getNotificationHistoryByType(String notificationType, Pageable pageable) {
        Page<NotificationHistory> historyPage = notificationHistoryRepository.findByNotificationType(notificationType,
                pageable);

        return historyPage.map(this::mapToNotificationHistoryDto);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<NotificationHistoryDto> getNotificationHistoryByStatus(boolean success, Pageable pageable) {
        Page<NotificationHistory> historyPage = notificationHistoryRepository.findBySuccess(success, pageable);

        return historyPage.map(this::mapToNotificationHistoryDto);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public NotificationHistoryStatsDto getNotificationHistoryStatistics() {
        long totalNotifications = notificationHistoryRepository.count();
        long successfulNotifications = notificationHistoryRepository.countBySuccess(true);
        long failedNotifications = notificationHistoryRepository.countBySuccess(false);

        List<Object[]> typeStats = notificationHistoryRepository.countByNotificationType();

        List<NotificationTypeStatDto> typeStatDtos = typeStats.stream()
                .map(obj -> NotificationTypeStatDto.builder()
                        .notificationType((String) obj[0])
                        .count((Long) obj[1])
                        .build())
                .collect(Collectors.toList());

        return NotificationHistoryStatsDto.builder()
                .totalNotifications(totalNotifications)
                .successfulNotifications(successfulNotifications)
                .failedNotifications(failedNotifications)
                .successRate(totalNotifications > 0
                        ? Math.round((double) successfulNotifications / totalNotifications * 10000.0) / 100.0
                        : 0)
                .typeStatistics(typeStatDtos)
                .build();
    }

    @AdminOnly
    @Transactional
    public int cleanupOldNotifications(int days) {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(days);
        int deletedCount = notificationHistoryRepository.deleteBySentAtBefore(cutoffDate);
        log.info("Удалено {} записей истории уведомлений старше {} дней", deletedCount, days);
        return deletedCount;
    }

    private UserWithTokenDto mapToUserWithTokenDto(User user) {
        return UserWithTokenDto.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .isOnline(user.getIsOnline())
                .hasPushToken(user.getEncryptedPushToken() != null)
                .createdAt(user.getCreatedAt())
                .lastOnline(user.getIsOnline() != null && user.getIsOnline() ? LocalDateTime.now() : null)
                .build();
    }

    private NotificationHistoryDto mapToNotificationHistoryDto(NotificationHistory history) {
        return NotificationHistoryDto.builder()
                .id(history.getId())
                .title(history.getTitle())
                .message(history.getMessage())
                .notificationType(history.getNotificationType())
                .targetUserId(history.getUserId())
                .sentAt(history.getSentAt())
                .success(history.isSuccess())
                .errorMessage(history.getErrorMessage())
                .status(history.isSuccess() ? "SUCCESS" : "FAILED")
                .build();
    }
}