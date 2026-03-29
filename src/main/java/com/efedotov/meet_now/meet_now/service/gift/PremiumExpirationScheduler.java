package com.efedotov.meet_now.meet_now.service.gift;

import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.moderation.RoleRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class PremiumExpirationScheduler {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    @Scheduled(cron = "0 0 2 * * ?")
    @Transactional
    public void revokeExpiredPremium() {
        log.info("Запуск проверки истекших премиум-статусов");
        LocalDateTime now = LocalDateTime.now();

        List<User> expiredUsers = userRepository.findByPremiumExpiresAtBeforeAndRoles_RoleName(now, "PREMIUM");
        if (expiredUsers.isEmpty()) {
            log.info("Нет пользователей с истекшим премиум-статусом");
            return;
        }

        Role premiumRole = roleRepository.findByRoleName("PREMIUM")
                .orElseThrow(() -> new IllegalStateException("Роль PREMIUM не найдена"));

        for (User user : expiredUsers) {
            user.getRoles().remove(premiumRole);
            userRepository.save(user);
            log.info("У пользователя {} отозвана роль PREMIUM (истек срок)", user.getId());
        }

        log.info("Отозвана роль PREMIUM у {} пользователей", expiredUsers.size());
    }
}