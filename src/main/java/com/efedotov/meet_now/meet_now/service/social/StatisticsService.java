package com.efedotov.meet_now.meet_now.service.social;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.messaging.MessagingException;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.dto.response.game.GameTypeStatisticDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftRarityStatisticDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftTypeStatisticDto;
import com.efedotov.meet_now.meet_now.dto.response.social.AgeGroupStatisticDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.AdminSystemStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.ChatStatistics;
import com.efedotov.meet_now.meet_now.dto.response.statistics.DailyUserGrowthDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.GameStatistics;
import com.efedotov.meet_now.meet_now.dto.response.statistics.GiftStatistics;
import com.efedotov.meet_now.meet_now.dto.response.statistics.RealtimeStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.ReportStatistics;
import com.efedotov.meet_now.meet_now.dto.response.statistics.SystemMetrics;
import com.efedotov.meet_now.meet_now.dto.response.statistics.UserGrowthStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.UserStatistics;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatGameRepository;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.repository.content.IcebreakerTopicRepository;
import com.efedotov.meet_now.meet_now.repository.content.StickerPackRepository;
import com.efedotov.meet_now.meet_now.repository.content.StickerRepository;
import com.efedotov.meet_now.meet_now.repository.gift.DailyGiftRepository;
import com.efedotov.meet_now.meet_now.repository.gift.GiftRarityRepository;
import com.efedotov.meet_now.meet_now.repository.gift.GiftRepository;
import com.efedotov.meet_now.meet_now.repository.gift.SentGiftRepository;
import com.efedotov.meet_now.meet_now.repository.gift.UserInventoryRepository;
import com.efedotov.meet_now.meet_now.repository.moderation.ReportRepository;
import com.efedotov.meet_now.meet_now.repository.user.CityRepository;
import com.efedotov.meet_now.meet_now.repository.user.InterestRepository;
import com.efedotov.meet_now.meet_now.repository.user.PurposeRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserSessionRepository;
import com.efedotov.meet_now.meet_now.dto.response.statistics.ReportReasonStatistic;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class StatisticsService {

    private final UserRepository userRepository;
    private final UserSessionRepository userSessionRepository;
    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final MessageRepository messageRepository;
    private final ReportRepository reportRepository;
    private final DailyGiftRepository dailyGiftRepository;
    private final SentGiftRepository sentGiftRepository;
    private final GiftRepository giftRepository;
    private final GiftRarityRepository giftRarityRepository;
    private final UserInventoryRepository userInventoryRepository;
    private final ChatGameRepository chatGameRepository;
    private final IcebreakerTopicRepository icebreakerTopicRepository;
    private final StickerPackRepository stickerPackRepository;
    private final StickerRepository stickerRepository;
    private final CityRepository cityRepository;
    private final InterestRepository interestRepository;
    private final PurposeRepository purposeRepository;
    private final SimpMessagingTemplate messagingTemplate;

    private final LocalDateTime systemStartTime = LocalDateTime.now();

    @AdminOnly
    @Transactional(readOnly = true)
    public AdminSystemStatisticsDto getAdminSystemStatistics() {
        UUID adminId = getCurrentAdminId();
        log.info("Admin {} requested system statistics", adminId);

        AdminSystemStatisticsDto statistics = new AdminSystemStatisticsDto();
        statistics.setUserStatistics(getUserStatistics());
        statistics.setChatStatistics(getChatStatistics());
        statistics.setGiftStatistics(getGiftStatistics());
        statistics.setGameStatistics(getGameStatistics());
        statistics.setReportStatistics(getReportStatistics());
        statistics.setSystemMetrics(getSystemMetrics());
        statistics.setGeneratedAt(LocalDateTime.now());

        return statistics;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private UserStatistics getUserStatistics() {
        LocalDateTime yesterday = LocalDateTime.now().minusHours(24);
        LocalDateTime lastWeek = LocalDateTime.now().minusDays(7);
        return UserStatistics.builder().totalUsers(userRepository.count())
                .onlineUsers(userRepository.countByIsOnlineTrue())
                .searchingUsers(userRepository.countByIsSearchingTrue())
                .searchableUsers(userRepository.countByIsSearchableTrue())
                .newUsersLast24h(userRepository.countByCreatedAtAfter(yesterday))
                .newUsersLast7d(userRepository.countByCreatedAtAfter(lastWeek))
                .verifiedUsers(userRepository.countByVerifiedTrue())
                .blockedUsers(userRepository.countByRoles_RoleName("BLOCKED"))
                .usersByCity(userRepository.countUsersByCity())
                .usersByAgeGroup(getUsersByAgeGroup())
                .build();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private ChatStatistics getChatStatistics() {
        ChatStatistics stats = new ChatStatistics();

        stats.setTotalChats(chatRepository.count());
        stats.setActiveChats(chatRepository.countByIsOpened(true));

        long totalTemporaryChats = temporaryChatRepository.count();
        stats.setTemporaryChats(totalTemporaryChats);
        stats.setFinishedTemporaryChats(temporaryChatRepository.countByIsFinished(true));

        stats.setTotalMessages(messageRepository.count());

        long totalChats = Math.max(stats.getTotalChats(), 1);
        stats.setAvgMessagesPerChat((double) stats.getTotalMessages() / totalChats);

        stats.setUnreadMessages(estimateUnreadMessages());

        return stats;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private GiftStatistics getGiftStatistics() {
        GiftStatistics stats = new GiftStatistics();

        stats.setTotalGifts(giftRepository.count());
        stats.setTotalSentGifts(sentGiftRepository.count());
        stats.setTotalDailyGifts(dailyGiftRepository.count());

        LocalDateTime yesterday = LocalDateTime.now().minusHours(24);
        stats.setGiftsSentLast24h(sentGiftRepository.countBySentAtAfter(yesterday));
        stats.setTotalInventoryItems(userInventoryRepository.count());
        stats.setGiftsByRarity(getGiftsByRarity());
        stats.setGiftsByType(getGiftsByType());

        return stats;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private GameStatistics getGameStatistics() {
        GameStatistics stats = new GameStatistics();

        stats.setTotalGamesPlayed(chatGameRepository.count());
        stats.setActiveGames(chatGameRepository.count());
        stats.setGamesByType(getGamesByType());
        stats.setTotalGamePoints(userRepository.sumGamePoints());

        long totalUsers = userRepository.count();
        if (totalUsers > 0) {
            stats.setAvgPointsPerUser((double) stats.getTotalGamePoints() / totalUsers);
        } else {
            stats.setAvgPointsPerUser(0.0);
        }

        return stats;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private ReportStatistics getReportStatistics() {
        ReportStatistics stats = new ReportStatistics();

        stats.setTotalReports(reportRepository.count());
        stats.setSentReports(
                reportRepository.countByStatus(com.efedotov.meet_now.meet_now.model.moderation.ReportStatus.SENT));
        stats.setInProcessReports(reportRepository
                .countByStatus(com.efedotov.meet_now.meet_now.model.moderation.ReportStatus.IN_PROCESS));
        stats.setCompletedReports(
                reportRepository.countByStatus(com.efedotov.meet_now.meet_now.model.moderation.ReportStatus.COMPLETED));

        List<ReportReasonStatistic> reportsByReasonList = getReportsByReason();
        stats.setReportsByReason(reportsByReasonList);

        return stats;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private SystemMetrics getSystemMetrics() {
        SystemMetrics metrics = new SystemMetrics();

        metrics.setTotalIcebreakerTopics(icebreakerTopicRepository.count());
        metrics.setTotalStickerPacks(stickerPackRepository.count());
        metrics.setTotalStickers(stickerRepository.count());
        metrics.setTotalCities(cityRepository.count());
        metrics.setTotalInterests(interestRepository.count());
        metrics.setTotalPurposes(purposeRepository.count());
        metrics.setActiveSessions(userSessionRepository.count());
        metrics.setSystemUptimeHours(calculateUptimeHours());

        return metrics;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private List<AgeGroupStatisticDto> getUsersByAgeGroup() {
        List<User> users = userRepository.findAll();

        return List.of(
                AgeGroupStatisticDto.builder().ageGroup("under_18").count(
                        users.stream().filter(u -> u.getAge() != null && u.getAge() < 18).count()).build(),
                AgeGroupStatisticDto.builder().ageGroup("18_25").count(
                        users.stream().filter(u -> u.getAge() != null && u.getAge() >= 18 && u.getAge() <= 25).count())
                        .build(),
                AgeGroupStatisticDto.builder().ageGroup("26_35").count(
                        users.stream().filter(u -> u.getAge() != null && u.getAge() >= 26 && u.getAge() <= 35).count())
                        .build(),
                AgeGroupStatisticDto.builder().ageGroup("36_45").count(
                        users.stream().filter(u -> u.getAge() != null && u.getAge() >= 36 && u.getAge() <= 45).count())
                        .build(),
                AgeGroupStatisticDto.builder().ageGroup("over_45").count(
                        users.stream().filter(u -> u.getAge() != null && u.getAge() > 45).count()).build(),
                AgeGroupStatisticDto.builder().ageGroup("unknown").count(
                        users.stream().filter(u -> u.getAge() == null).count()).build());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private long estimateUnreadMessages() {
        return messageRepository.count() / 10;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private List<GiftRarityStatisticDto> getGiftsByRarity() {
        return giftRarityRepository.findAll().stream()
                .map(rarity -> GiftRarityStatisticDto.builder()
                        .rarityName(rarity.getName())
                        .count((long) giftRepository.findByRarityAndIsActiveTrue(rarity).size())
                        .build())
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private List<GiftTypeStatisticDto> getGiftsByType() {
        Map<String, Long> giftsByTypeMap = new HashMap<>();
        giftRepository.findAll().forEach(gift -> {
            if (gift.getGiftType() != null) {
                String typeName = gift.getGiftType().getTypeName();
                giftsByTypeMap.put(typeName, giftsByTypeMap.getOrDefault(typeName, 0L) + 1);
            }
        });

        return giftsByTypeMap.entrySet().stream()
                .map(entry -> GiftTypeStatisticDto.builder()
                        .typeName(entry.getKey())
                        .count(entry.getValue())
                        .build())
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private List<GameTypeStatisticDto> getGamesByType() {
        Map<String, Long> gamesByTypeMap = new HashMap<>();

        chatGameRepository.findAll().forEach(game -> {
            String gameType = game.getGameType();
            gamesByTypeMap.put(gameType, gamesByTypeMap.getOrDefault(gameType, 0L) + 1);
        });

        return gamesByTypeMap.entrySet().stream()
                .map(entry -> GameTypeStatisticDto.builder()
                        .gameType(entry.getKey())
                        .count(entry.getValue())
                        .build())
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private List<ReportReasonStatistic> getReportsByReason() {
        Map<String, Long> reportsByReasonMap = new HashMap<>();

        reportRepository.findAll().forEach(report -> {
            String reason = report.getReason();
            if (reason != null && !reason.trim().isEmpty()) {
                String key = reason.length() > 20 ? reason.substring(0, 20) + "..." : reason;
                reportsByReasonMap.put(key, reportsByReasonMap.getOrDefault(key, 0L) + 1);
            } else {
                reportsByReasonMap.put("No reason", reportsByReasonMap.getOrDefault("No reason", 0L) + 1);
            }
        });

        return reportsByReasonMap.entrySet().stream()
                .map(entry -> {
                    ReportReasonStatistic statistic = new ReportReasonStatistic();
                    statistic.setReason(entry.getKey());
                    statistic.setCount(entry.getValue());
                    return statistic;
                })
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private double calculateUptimeHours() {
        return ChronoUnit.HOURS.between(systemStartTime, LocalDateTime.now());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public RealtimeStatisticsDto getRealtimeStatistics() {
        UUID adminId = getCurrentAdminId();
        log.info("Admin {} requested realtime statistics", adminId);

        return RealtimeStatisticsDto.builder()
                .onlineUsers(userRepository.countByIsOnlineTrue())
                .searchingUsers(userRepository.countByIsSearchingTrue())
                .activeChats(chatRepository.countByIsOpened(true))
                .activeTemporaryChats(temporaryChatRepository.countByIsFinished(false))
                .activeSessions(userSessionRepository.count())
                .systemUptimeHours(calculateUptimeHours())
                .timestamp(LocalDateTime.now())
                .build();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public UserGrowthStatisticsDto getUserGrowthStatistics(int days) {
        UUID adminId = getCurrentAdminId();
        log.info("Admin {} requested user growth statistics for {} days", adminId, days);

        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = endDate.minusDays(days);

        List<DailyUserGrowthDto> dailyGrowth = new ArrayList<>();

        for (int i = 0; i <= days; i++) {
            LocalDateTime date = startDate.plusDays(i);
            long usersCount = userRepository.countByCreatedAtBefore(date);
            long newUsers = userRepository.countByCreatedAtBetween(date.minusDays(1), date);

            dailyGrowth.add(DailyUserGrowthDto.builder()
                    .date(date.toLocalDate())
                    .totalUsers(usersCount)
                    .newUsers(newUsers)
                    .build());
        }

        return UserGrowthStatisticsDto.builder()
                .period(days + " days")
                .startDate(startDate.toLocalDate())
                .endDate(endDate.toLocalDate())
                .totalGrowth(userRepository.countByCreatedAtAfter(startDate))
                .dailyData(dailyGrowth)
                .build();
    }

    @AdminOnly
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

    @Transactional(readOnly = true)
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

    @Transactional(readOnly = true)
    public void refreshAndBroadcastStats() {
        log.debug("Принудительное обновление статистики");
        broadcastUserStats();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public UserStatsDto getCachedStats() {
        return getUserStats();
    }

    private UUID getCurrentAdminId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            return ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        } else {
            return null;
        }
    }
}