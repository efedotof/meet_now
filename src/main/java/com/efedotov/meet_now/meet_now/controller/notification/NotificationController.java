package com.efedotov.meet_now.meet_now.controller.notification;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.notification.NotificationLogRequest;
import com.efedotov.meet_now.meet_now.dto.request.notification.NotificationRequest;
import com.efedotov.meet_now.meet_now.dto.request.notification.PushTokenRequest;
import com.efedotov.meet_now.meet_now.dto.response.notification.NotificationHistoryDto;
import com.efedotov.meet_now.meet_now.dto.response.notification.NotificationHistoryStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.notification.NotificationStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.notification.TokenCoverageDto;
import com.efedotov.meet_now.meet_now.dto.response.notification.UserTokenStatusDto;
import com.efedotov.meet_now.meet_now.dto.response.notification.UserWithTokenDto;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.notification.FCMNotificationService;
import com.efedotov.meet_now.meet_now.service.notification.NotificationStatisticsService;
import com.efedotov.meet_now.meet_now.service.notification.PushTokenService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final FCMNotificationService notificationService;
    private final PushTokenService pushTokenService;
    private final NotificationStatisticsService notificationStatisticsService;

    @PostMapping("/register-token")
    public ResponseEntity<?> registerPushToken(
            @RequestBody PushTokenRequest request) {

        pushTokenService.savePushTokenForCurrentUser(request.getPushToken());
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/unregister-token")
    public ResponseEntity<?> unregisterPushToken() {
        pushTokenService.removePushTokenForCurrentUser();
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @PostMapping("/token/{pushToken}")
    public ResponseEntity<?> sendTokenNotification(
            @PathVariable String pushToken,
            @RequestBody NotificationRequest request) {

        notificationService.sendNotificationToToken(pushToken, request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @PostMapping("/user/{userId}")
    public ResponseEntity<?> sendUserNotification(
            @PathVariable UUID userId,
            @RequestBody NotificationRequest request) {

        notificationService.sendNotificationToUser(userId, request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @PostMapping("/user/allUserNotifications")
    public ResponseEntity<?> sendAllUserNotification(@RequestBody NotificationRequest request) {
        notificationService.sendAllNotificationToAllUser(request.getMessage(), request.getTitle());
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @PostMapping("/data/{pushToken}")
    public ResponseEntity<?> sendDataNotification(
            @PathVariable String pushToken,
            @RequestBody NotificationRequest request) {

        java.util.Map<String, String> data = new java.util.HashMap<>();
        data.put("type", "system");
        data.put("action", request.getAction() != null ? request.getAction() : "info");

        notificationService.sendDataNotificationToToken(pushToken, request.getMessage(),
                request.getTitle(), data);
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @GetMapping("/admin/statistics")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить статистику уведомлений", description = "Возвращает статистику по push-токенам и уведомлениям. Только для администраторов")
    public ResponseEntity<NotificationStatisticsDto> getNotificationStatistics() {
        NotificationStatisticsDto statistics = notificationStatisticsService.getNotificationStatistics();
        return ResponseEntity.ok(statistics);
    }

    @AdminOnly
    @GetMapping("/admin/statistics/users-with-tokens")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить список пользователей с push-токенами", description = "Возвращает список пользователей, у которых зарегистрированы push-токены. Только для администраторов")
    public ResponseEntity<List<UserWithTokenDto>> getUsersWithPushTokens() {
        List<UserWithTokenDto> users = notificationStatisticsService.getUsersWithPushTokens();
        return ResponseEntity.ok(users);
    }

    @AdminOnly
    @GetMapping("/admin/statistics/online-users-with-tokens")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить онлайн пользователей с push-токенами", description = "Возвращает список онлайн пользователей с зарегистрированными push-токенами. Только для администраторов")
    public ResponseEntity<List<UserWithTokenDto>> getOnlineUsersWithPushTokens() {
        List<UserWithTokenDto> users = notificationStatisticsService.getOnlineUsersWithPushTokens();
        return ResponseEntity.ok(users);
    }

    @AdminOnly
    @GetMapping("/admin/statistics/user-token-status/{userId}")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить статус push-токена пользователя", description = "Возвращает информацию о push-токене конкретного пользователя. Только для администраторов")
    public ResponseEntity<UserTokenStatusDto> getUserTokenStatus(@PathVariable UUID userId) {
        UserTokenStatusDto status = notificationStatisticsService.getUserTokenStatus(userId);
        return ResponseEntity.ok(status);
    }

    @AdminOnly
    @GetMapping("/admin/statistics/token-coverage")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить охват push-токенами", description = "Возвращает статистику охвата push-токенами среди пользователей. Только для администраторов")
    public ResponseEntity<TokenCoverageDto> getTokenCoverageStatistics() {
        TokenCoverageDto coverage = notificationStatisticsService.getTokenCoverageStatistics();
        return ResponseEntity.ok(coverage);
    }

    @AdminOnly
    @PostMapping("/admin/log")
    @Operation(summary = "[АДМИНИСТРАТОР] Записать отправку уведомления в историю", description = "Сохраняет информацию об отправленном уведомлении в историю. Только для администраторов")
    public ResponseEntity<String> logNotification(@RequestBody NotificationLogRequest request) {
        notificationStatisticsService.logNotification(
                request.getUserId(),
                request.getTitle(),
                request.getMessage(),
                request.getNotificationType(),
                request.isSuccess(),
                request.getErrorMessage());
        return ResponseEntity.ok("Уведомление записано в историю");
    }

    @AdminOnly
    @GetMapping("/admin/history")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить историю уведомлений", description = "Возвращает историю отправленных уведомлений с пагинацией. Только для администраторов")
    public ResponseEntity<Page<NotificationHistoryDto>> getNotificationHistory(Pageable pageable) {
        Page<NotificationHistoryDto> history = notificationStatisticsService.getNotificationHistory(pageable);
        return ResponseEntity.ok(history);
    }

    @AdminOnly
    @GetMapping("/admin/history/user/{userId}")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить историю уведомлений пользователя", description = "Возвращает историю уведомлений конкретного пользователя. Только для администраторов")
    public ResponseEntity<Page<NotificationHistoryDto>> getUserNotificationHistory(
            @PathVariable UUID userId,
            Pageable pageable) {
        Page<NotificationHistoryDto> history = notificationStatisticsService.getUserNotificationHistory(userId,
                pageable);
        return ResponseEntity.ok(history);
    }

    @AdminOnly
    @GetMapping("/admin/history/type/{notificationType}")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить историю уведомлений по типу", description = "Возвращает историю уведомлений определенного типа. Только для администраторов")
    public ResponseEntity<Page<NotificationHistoryDto>> getNotificationHistoryByType(
            @PathVariable String notificationType,
            Pageable pageable) {
        Page<NotificationHistoryDto> history = notificationStatisticsService
                .getNotificationHistoryByType(notificationType, pageable);
        return ResponseEntity.ok(history);
    }

    @AdminOnly
    @GetMapping("/admin/history/status/{status}")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить историю уведомлений по статусу", description = "Возвращает историю уведомлений по статусу отправки. Только для администраторов")
    public ResponseEntity<Page<NotificationHistoryDto>> getNotificationHistoryByStatus(
            @PathVariable boolean status,
            Pageable pageable) {
        Page<NotificationHistoryDto> history = notificationStatisticsService.getNotificationHistoryByStatus(status,
                pageable);
        return ResponseEntity.ok(history);
    }

    @AdminOnly
    @GetMapping("/admin/history/stats")
    @Operation(summary = "[АДМИНИСТРАТОР] Получить статистику истории уведомлений", description = "Возвращает статистику по истории уведомлений. Только для администраторов")
    public ResponseEntity<NotificationHistoryStatsDto> getNotificationHistoryStatistics() {
        NotificationHistoryStatsDto stats = notificationStatisticsService.getNotificationHistoryStatistics();
        return ResponseEntity.ok(stats);
    }

    @AdminOnly
    @DeleteMapping("/admin/history/cleanup")
    @Operation(summary = "[АДМИНИСТРАТОР] Очистить старую историю уведомлений", description = "Удаляет записи истории уведомлений старше указанного количества дней. Только для администраторов")
    public ResponseEntity<String> cleanupOldNotifications(@RequestParam(defaultValue = "30") int days) {
        int deletedCount = notificationStatisticsService.cleanupOldNotifications(days);
        return ResponseEntity.ok("Удалено " + deletedCount + " записей старше " + days + " дней");
    }

}