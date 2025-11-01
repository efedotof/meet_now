package com.efedotov.meet_now.meet_now.service.social;

import org.springframework.messaging.MessagingException;
import com.efedotov.meet_now.meet_now.dto.response.social.UserStatsDto;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class StatisticsService {

    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public UserStatsDto getUserStats() {
        long onlineCount = userRepository.countByIsOnlineTrue();
        long searchingCount = userRepository.countByIsSearchingTrue();
        return new UserStatsDto(onlineCount, searchingCount);
    }

    public void broadcastUserStats() {
        try {
            UserStatsDto stats = getUserStats();
            messagingTemplate.convertAndSend("/topic/userstats", stats);
            log.debug("Статистика отправлена: онлайн={}, в поиске={}",
                    stats.getOnlineCount(), stats.getSearchingCount());
        } catch (MessagingException e) {
            log.error("Ошибка при отправке статистики", e);
        }
    }
}