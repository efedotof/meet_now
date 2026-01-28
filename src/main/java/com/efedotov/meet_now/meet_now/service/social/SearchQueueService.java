package com.efedotov.meet_now.meet_now.service.social;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.request.search.SearchFilters;
import com.efedotov.meet_now.meet_now.dto.request.search.SearchRequest;
import com.efedotov.meet_now.meet_now.dto.request.search.SearchStatus;
import com.efedotov.meet_now.meet_now.dto.response.chat.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.dto.response.search.QueueSizeDto;
import com.efedotov.meet_now.meet_now.dto.response.search.QueueStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.search.UserWaitingTimeDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;

import org.springframework.messaging.MessagingException;

@Slf4j
@Service
@RequiredArgsConstructor
public class SearchQueueService {
    private final Queue<UUID> defaultSearchQueue = new ConcurrentLinkedQueue<>();
    private final Map<UUID, SearchRequest> searchRequests = new ConcurrentHashMap<>();
    private final Map<String, Queue<UUID>> filteredQueues = new ConcurrentHashMap<>();
    private final UserRepository userRepository;
    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    @Transactional
    public synchronized void addToSearch(UUID userId, SearchFilters filters) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!user.getIsOnline() || !user.getIsSearchable()) {
            throw new RuntimeException("User is not available for search");
        }

        user.setIsSearching(true);
        userRepository.save(user);

        SearchRequest request = SearchRequest.builder()
                .userId(userId)
                .filters(filters)
                .addedAt(LocalDateTime.now())
                .build();

        searchRequests.put(userId, request);

        String queueKey = generateQueueKey(filters);
        filteredQueues.computeIfAbsent(queueKey, k -> new ConcurrentLinkedQueue<>())
                .add(userId);

        log.info("User {} added to search queue with filters: {}", userId, filters);

        tryFindMatch(userId, filters);
    }

    @Transactional
    public synchronized void removeFromSearch(UUID userId) {
        SearchRequest request = searchRequests.remove(userId);
        if (request != null) {
            String queueKey = generateQueueKey(request.getFilters());
            Queue<UUID> queue = filteredQueues.get(queueKey);
            if (queue != null) {
                queue.remove(userId);
                if (queue.isEmpty()) {
                    filteredQueues.remove(queueKey);
                }
            }

            User user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                user.setIsSearching(false);
                userRepository.save(user);
            }

            log.info("User {} removed from search queue", userId);
        }
    }

    private void tryFindMatch(UUID userId, SearchFilters filters) {
        String queueKey = generateQueueKey(filters);
        Queue<UUID> queue = filteredQueues.get(queueKey);

        if (queue == null || queue.size() < 2) {
            return;
        }

        List<UUID> candidates = new ArrayList<>(queue);
        candidates.remove(userId);

        for (UUID candidateId : candidates) {
            if (isCompatible(userId, candidateId, filters)) {
                createChatForPair(userId, candidateId);
                return;
            }
        }
    }

    private boolean isCompatible(UUID user1Id, UUID user2Id, SearchFilters filters) {
        try {
            User user1 = userRepository.findById(user1Id).orElse(null);
            User user2 = userRepository.findById(user2Id).orElse(null);

            if (user1 == null || user2 == null)
                return false;

            if (!user2.getIsOnline() || !user2.getIsSearchable() || !user2.getIsSearching()) {
                return false;
            }

            return matchesFilters(user2, filters);

        } catch (Exception e) {
            log.error("Error checking compatibility", e);
            return false;
        }
    }

    @Transactional
    public void createChatForPair(UUID user1Id, UUID user2Id) {
        try {
            User user1 = userRepository.findById(user1Id)
                    .orElseThrow(() -> new RuntimeException("User1 not found"));
            User user2 = userRepository.findById(user2Id)
                    .orElseThrow(() -> new RuntimeException("User2 not found"));

            user1.setIsSearching(false);
            user2.setIsSearching(false);
            userRepository.save(user1);
            userRepository.save(user2);

            removeFromSearch(user1Id);
            removeFromSearch(user2Id);

            UserDto user1Dto = createUserDto(user1);
            UserDto user2Dto = createUserDto(user2);

            var tempChat = chatService.createTemporaryChat(user1Dto, user2Dto, 5);

            TemporaryChatDto dto = TemporaryChatDto.builder()
                    .tempChatId(tempChat.getTempChatId())
                    .senderId(user1.getId())
                    .recipientId(user2.getId())
                    .createdAt(tempChat.getCreatedAt())
                    .durationMinutes(tempChat.getDurationMinutes())
                    .isFinished(tempChat.getIsFinished())
                    .bothAgreed(tempChat.getBothAgreed())
                    .build();

            messagingTemplate.convertAndSendToUser(
                    user1.getUsername(),
                    "/queue/chat.temporary.new",
                    dto);
            messagingTemplate.convertAndSendToUser(
                    user2.getUsername(),
                    "/queue/chat.temporary.new",
                    dto);

            log.info("Created chat between {} and {}", user1Id, user2Id);

        } catch (MessagingException e) {
            log.error("Error creating chat for pair", e);
            userRepository.findById(user1Id).ifPresent(u -> {
                u.setIsSearching(true);
                userRepository.save(u);
            });
            userRepository.findById(user2Id).ifPresent(u -> {
                u.setIsSearching(true);
                userRepository.save(u);
            });
        }
    }

    private UserDto createUserDto(User user) {
        UserDto dto = new UserDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFirstname(user.getFirstname());
        dto.setSubname(user.getSubname());
        dto.setDescription(user.getDescription());
        dto.setAvatar(user.getAvatar());
        dto.setCity(user.getCity());
        dto.setAge(user.getAge());
        dto.setPurposes(user.getPurposes());
        dto.setInterests(user.getInterests());
        dto.setCreatedAt(user.getCreatedAt());
        dto.setVerified(user.getVerified());
        dto.setIsSearchable(user.getIsSearchable());
        dto.setIsOnline(user.getIsOnline());
        dto.setFloor(user.getFloor());
        dto.setGamePoints(user.getGamePoints());
        dto.setImages(user.getImages());
        dto.setIsBlocked(user.getIsBlocked());
        dto.setBlockReason(user.getBlockReason());
        return dto;
    }

    @Scheduled(fixedDelay = 5000)
    @Transactional
    public void processSearchQueues() {
        log.debug("Processing search queues, total active searches: {}", searchRequests.size());

        cleanupOldRequests();

        for (Map.Entry<String, Queue<UUID>> entry : filteredQueues.entrySet()) {
            processQueue(entry.getValue());
        }
    }

    private void processQueue(Queue<UUID> queue) {
        if (queue.size() < 2)
            return;

        List<UUID> users = new ArrayList<>(queue);

        for (int i = 0; i < users.size() - 1; i++) {
            for (int j = i + 1; j < users.size(); j++) {
                UUID user1 = users.get(i);
                UUID user2 = users.get(j);

                if (!searchRequests.containsKey(user1) || !searchRequests.containsKey(user2)) {
                    continue;
                }

                SearchFilters filters1 = searchRequests.get(user1).getFilters();
                SearchFilters filters2 = searchRequests.get(user2).getFilters();

                if (isCompatible(user1, user2, filters1) && isCompatible(user2, user1, filters2)) {
                    createChatForPair(user1, user2);
                    return;
                }
            }
        }
    }

    private void cleanupOldRequests() {
        LocalDateTime cutoff = LocalDateTime.now().minusMinutes(30);

        Iterator<Map.Entry<UUID, SearchRequest>> iterator = searchRequests.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<UUID, SearchRequest> entry = iterator.next();
            if (entry.getValue().getAddedAt().isBefore(cutoff)) {
                UUID userId = entry.getKey();
                removeFromSearch(userId);
                iterator.remove();
                log.warn("Removed stale search request for user {}", userId);
            }
        }
    }

    private String generateQueueKey(SearchFilters filters) {
        return String.format("%s_%s_%s_%s_%s_%s_%s_%s",
                filters.getFloor() != null ? filters.getFloor() : "any",
                filters.getVerified() != null ? filters.getVerified() : "any",
                filters.getCity() != null ? filters.getCity() : "any",
                filters.getAgeStart() != null ? filters.getAgeStart() : "any",
                filters.getAgeStop() != null ? filters.getAgeStop() : "any",
                filters.getInterests() != null ? String.join(",", filters.getInterests()) : "any",
                filters.getPurposes() != null ? String.join(",", filters.getPurposes()) : "any",
                "default");
    }

    private boolean matchesFilters(User user, SearchFilters filters) {
        if (filters.getFloor() != null && !filters.getFloor().equals(user.getFloor())) {
            return false;
        }
        if (filters.getVerified() != null && !filters.getVerified().equals(user.getVerified())) {
            return false;
        }
        if (filters.getCity() != null && !filters.getCity().equals(user.getCity())) {
            return false;
        }
        if (filters.getAgeStart() != null && user.getAge() < filters.getAgeStart()) {
            return false;
        }
        if (filters.getAgeStop() != null && user.getAge() > filters.getAgeStop()) {
            return false;
        }

        if (filters.getInterests() != null && !filters.getInterests().isEmpty()) {
            List<String> userInterests = user.getInterests();
            if (userInterests == null || userInterests.isEmpty()) {
                return false;
            }
            boolean hasCommonInterest = userInterests.stream()
                    .anyMatch(filters.getInterests()::contains);
            if (!hasCommonInterest) {
                return false;
            }
        }

        if (filters.getPurposes() != null && !filters.getPurposes().isEmpty()) {
            List<String> userPurposes = user.getPurposes();
            if (userPurposes == null || userPurposes.isEmpty()) {
                return false;
            }
            boolean hasCommonPurpose = userPurposes.stream()
                    .anyMatch(filters.getPurposes()::contains);
            if (!hasCommonPurpose) {
                return false;
            }
        }

        return true;
    }

    public SearchStatus getSearchStatus(UUID userId) {
        boolean isSearching = searchRequests.containsKey(userId);
        SearchRequest request = searchRequests.get(userId);

        Integer queuePosition = null;
        Integer totalInQueue = null;

        if (request != null) {
            String queueKey = generateQueueKey(request.getFilters());
            Queue<UUID> queue = filteredQueues.get(queueKey);
            if (queue != null) {
                totalInQueue = queue.size();
                int position = 1;
                for (UUID uid : queue) {
                    if (uid.equals(userId)) {
                        queuePosition = position;
                        break;
                    }
                    position++;
                }
            }
        }

        return SearchStatus.builder()
                .isSearching(isSearching)
                .searchingSince(request != null ? request.getAddedAt() : null)
                .filters(request != null ? request.getFilters() : null)
                .queuePosition(queuePosition)
                .totalInQueue(totalInQueue)
                .build();
    }

    public int getActiveSearchCount() {
        return searchRequests.size();
    }

   public QueueStatsDto getQueueStats() {
    List<QueueSizeDto> queueSizes = new ArrayList<>();
    for (Map.Entry<String, Queue<UUID>> entry : filteredQueues.entrySet()) {
        queueSizes.add(QueueSizeDto.builder()
                .queueKey(entry.getKey())
                .size(entry.getValue().size())
                .build());
    }

    List<UserWaitingTimeDto> waitingTimes = new ArrayList<>();
    LocalDateTime now = LocalDateTime.now();
    for (Map.Entry<UUID, SearchRequest> entry : searchRequests.entrySet()) {
        long minutesWaiting = java.time.Duration.between(entry.getValue().getAddedAt(), now).toMinutes();
        waitingTimes.add(UserWaitingTimeDto.builder()
                .userId(entry.getKey())
                .waitingMinutes(minutesWaiting)
                .build());
    }

    return QueueStatsDto.builder()
            .totalActiveSearches(searchRequests.size())
            .totalQueues(filteredQueues.size())
            .queueSizes(queueSizes)
            .waitingTimes(waitingTimes)
            .build();
}

    @Transactional
    public void clearAllQueues() {
        log.info("Clearing all search queues, affected users: {}", searchRequests.size());

        for (UUID userId : searchRequests.keySet()) {
            User user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                user.setIsSearching(false);
                userRepository.save(user);
            }
        }

        defaultSearchQueue.clear();
        searchRequests.clear();
        filteredQueues.clear();

        log.info("All search queues cleared");
    }

    public List<UUID> getAllSearchingUsers() {
        return new ArrayList<>(searchRequests.keySet());
    }

    @Transactional
    public boolean forceStopSearch(UUID userId) {
        if (searchRequests.containsKey(userId)) {
            removeFromSearch(userId);
            return true;
        }
        return false;
    }
}