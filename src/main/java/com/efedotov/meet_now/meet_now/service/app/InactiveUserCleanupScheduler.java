package com.efedotov.meet_now.meet_now.service.app;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class InactiveUserCleanupScheduler {

    private final UserCleanupService userCleanupService;

    @Scheduled(cron = "${app.cleanup.inactive-users-cron:0 0 3 * * ?}")
    public void cleanupInactiveUsers() {
        log.info("Starting scheduled cleanup of inactive users...");
        userCleanupService.deleteUsersInactiveForDays(30);
        log.info("Scheduled cleanup finished.");
    }
}