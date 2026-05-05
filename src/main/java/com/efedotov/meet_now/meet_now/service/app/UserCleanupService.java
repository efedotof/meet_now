package com.efedotov.meet_now.meet_now.service.app;

import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.service.social.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserCleanupService {

    private final UserRepository userRepository;
    private final UserService userService;

    @Transactional
    public void deleteUsersInactiveForDays(int days) {
        LocalDateTime threshold = LocalDateTime.now().minusDays(days);
        LocalDateTime now = LocalDateTime.now();

        List<User> inactiveUsers = userRepository.findInactiveNonPrivilegedUsers(threshold, now);

        log.info("Found {} inactive users (excluding moderators/admins/premium) with last login before {}",
                inactiveUsers.size(), threshold);

        for (User user : inactiveUsers) {
            try {
                userService.deleteUserCompletely(user.getId());
                log.info("Successfully deleted inactive user: {}", user.getId());
            } catch (Exception e) {
                log.error("Error deleting inactive user {}: {}", user.getId(), e.getMessage(), e);
            }
        }
    }
}