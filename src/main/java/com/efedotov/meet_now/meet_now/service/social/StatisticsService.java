package com.efedotov.meet_now.meet_now.service.social;

import org.springframework.messaging.MessagingException;
import com.efedotov.meet_now.meet_now.dto.response.social.UserStatsDto;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class StatisticsService {

    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;

    @Transactional(readOnly = true)
    public UserStatsDto getUserStats() {
        try {
            long onlineCount = userRepository.countByIsOnlineTrue();
            long searchingCount = userRepository.countByIsSearchingTrue();
            
            log.debug("Получена статистика из БД: онлайн={}, в поиске={}", onlineCount, searchingCount);
            
            return new UserStatsDto(onlineCount, searchingCount);
        } catch (Exception e) {
            log.error("Ошибка при получении статистики из БД", e);
            return new UserStatsDto(0L, 0L);
        }
    }

    public void broadcastUserStats() {
        try {
            UserStatsDto stats = getUserStats();
            messagingTemplate.convertAndSend("/topic/userstats", stats);
            log.debug("Статистика отправлена в WebSocket: онлайн={}, в поиске={}",
                    stats.getOnlineCount(), stats.getSearchingCount());
        } catch (MessagingException e) {
            log.error("Ошибка при отправке статистики", e);
        } catch (Exception e) {
            log.error("Неожиданная ошибка при отправке статистики", e);
        }
    }

    public void refreshAndBroadcastStats() {
        log.debug("Принудительное обновление статистики");
        broadcastUserStats();
    }

    @Transactional(readOnly = true)
    public UserStatsDto getCachedStats() {
        return getUserStats(); 
    }
}