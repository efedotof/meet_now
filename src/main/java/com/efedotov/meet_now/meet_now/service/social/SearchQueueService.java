package com.efedotov.meet_now.meet_now.service.social;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Queue;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;

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
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.search.MatchDeliveryState;
import com.efedotov.meet_now.meet_now.model.search.MatchDeliveryStatus;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.repository.user.MatchDeliveryStateRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class SearchQueueService {
    private final Map<UUID, SearchRequest> searchRequests = new ConcurrentHashMap<>();
    private final Queue<UUID> waitingUsers = new ConcurrentLinkedQueue<>();
    private final Map<UUID, UUID> matchedChatsCache = new ConcurrentHashMap<>();
    private final UserRepository userRepository;
    private final ChatService chatService;
    private final TemporaryChatRepository temporaryChatRepository;
    private final MatchDeliveryStateRepository matchDeliveryStateRepository;

    @Transactional
    public synchronized SearchStatus startSearch(UUID userId, SearchFilters filters) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!user.getIsOnline() || !user.getIsSearchable()) {
            throw new RuntimeException("User is not available for search");
        }

        List<MatchDeliveryState> activeDeliveries = matchDeliveryStateRepository.findByUserIdAndStatus(
                userId, MatchDeliveryStatus.PENDING);

        if (activeDeliveries.isEmpty()) {
            activeDeliveries = matchDeliveryStateRepository.findByUserIdAndStatus(
                    userId, MatchDeliveryStatus.PARTIALLY_DELIVERED);
        }

        if (!activeDeliveries.isEmpty()) {
            MatchDeliveryState delivery = activeDeliveries.get(0);
            TemporaryChat chat = temporaryChatRepository
                    .findByTempChatId(delivery.getChatId())
                    .orElse(null);

            if (chat != null && !chat.getIsFinished()) {
                user.setIsSearching(false);
                userRepository.save(user);
                removeFromSearch(userId);

                matchedChatsCache.put(userId, chat.getTempChatId());

                return SearchStatus.builder()
                        .isSearching(false)
                        .searchingSince(null)
                        .filters(null)
                        .queuePosition(null)
                        .totalInQueue(null)
                        .matchedChat(convertToDto(chat))
                        .matchStatus("MATCH_FOUND")
                        .build();
            }
        }

        matchedChatsCache.remove(userId);

        user.setIsSearching(true);
        userRepository.save(user);

        SearchRequest request = SearchRequest.builder()
                .userId(userId)
                .filters(filters)
                .addedAt(LocalDateTime.now())
                .build();

        searchRequests.put(userId, request);

        log.info("User {} added to search queue with filters: {}", userId, filters);

        SearchStatus immediateMatch = tryFindMatch(userId, filters);
        if (immediateMatch != null && immediateMatch.getMatchedChat() != null) {
            return immediateMatch;
        }

        waitingUsers.add(userId);
        log.info("User {} waiting in queue, total waiting: {}", userId, waitingUsers.size());

        return SearchStatus.builder()
                .isSearching(true)
                .searchingSince(request.getAddedAt())
                .filters(filters)
                .queuePosition(getQueuePosition(userId))
                .totalInQueue(waitingUsers.size())
                .matchedChat(null)
                .matchStatus("SEARCHING")
                .build();
    }

    private SearchStatus tryFindMatch(UUID userId, SearchFilters filters) {
        if (searchRequests.size() < 2) {
            return null;
        }

        User currentUser = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<UUID> waitingCopy = new ArrayList<>(waitingUsers);

        waitingCopy.sort((id1, id2) -> {
            SearchRequest r1 = searchRequests.get(id1);
            SearchRequest r2 = searchRequests.get(id2);
            if (r1 == null || r2 == null)
                return 0;
            return r1.getAddedAt().compareTo(r2.getAddedAt());
        });

        for (UUID candidateId : waitingCopy) {
            if (candidateId.equals(userId)) {
                continue;
            }

            SearchRequest candidateRequest = searchRequests.get(candidateId);
            if (candidateRequest == null) {
                continue;
            }

            User candidate = userRepository.findById(candidateId)
                    .orElse(null);

            if (candidate == null) {
                continue;
            }

            if (areUsersCompatible(currentUser, candidate, filters, candidateRequest.getFilters())) {
                TemporaryChatDto chat = createChatForPair(userId, candidateId);
                if (chat != null) {
                    matchedChatsCache.put(userId, chat.getTempChatId());
                    matchedChatsCache.put(candidateId, chat.getTempChatId());

                    removeFromSearch(userId);
                    removeFromSearch(candidateId);

                    log.info("MATCH FOUND: {} <-> {}", userId, candidateId);

                    return SearchStatus.builder()
                            .isSearching(false)
                            .searchingSince(null)
                            .filters(null)
                            .queuePosition(null)
                            .totalInQueue(null)
                            .matchedChat(chat)
                            .matchStatus("MATCH_FOUND")
                            .build();
                }
            }
        }
        return null;
    }

    private boolean areUsersCompatible(User user1, User user2,
            SearchFilters filters1, SearchFilters filters2) {
        if (!user1.getIsOnline() || !user1.getIsSearchable() || !user1.getIsSearching() ||
                !user2.getIsOnline() || !user2.getIsSearchable() || !user2.getIsSearching()) {
            return false;
        }

        boolean user1MatchesUser2 = matchesFilters(user2, filters1);
        boolean user2MatchesUser1 = matchesFilters(user1, filters2);

        return user1MatchesUser2 && user2MatchesUser1;
    }

    private boolean matchesFilters(User user, SearchFilters filters) {
        String filterGender = filters.getFloor();
        if (filterGender != null && !"any".equals(filterGender)) {
            if (!filterGender.equals(user.getFloor())) {
                return false;
            }
        }

        if (filters.getVerified() != null && filters.getVerified() && !user.getVerified()) {
            return false;
        }

        if (filters.getCity() != null && !filters.getCity().isEmpty()) {
            String userCity = user.getCity();
            if (userCity == null || !userCity.equals(filters.getCity())) {
                return false;
            }
        }

        Integer userAge = user.getAge();
        if (userAge != null) {
            if (filters.getAgeStart() != null && userAge < filters.getAgeStart()) {
                return false;
            }
            if (filters.getAgeStop() != null && userAge > filters.getAgeStop()) {
                return false;
            }
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

    @Transactional
    public synchronized void removeFromSearch(UUID userId) {
        SearchRequest request = searchRequests.remove(userId);
        if (request != null) {
            waitingUsers.remove(userId);

            User user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                user.setIsSearching(false);
                userRepository.save(user);
            }

            log.info("User {} removed from search queue", userId);
        }
    }

    @Transactional
    public TemporaryChatDto createChatForPair(UUID user1Id, UUID user2Id) {
        try {
            User user1 = userRepository.findById(user1Id)
                    .orElseThrow(() -> new RuntimeException("User1 not found"));
            User user2 = userRepository.findById(user2Id)
                    .orElseThrow(() -> new RuntimeException("User2 not found"));

            UserDto user1Dto = createUserDto(user1);
            UserDto user2Dto = createUserDto(user2);

            var tempChat = chatService.createTemporaryChat(user1Dto, user2Dto, 5);

            user1.setIsSearching(false);
            user2.setIsSearching(false);
            userRepository.save(user1);
            userRepository.save(user2);

            log.info("Created temporary chat between {} and {} with id: {}",
                    user1Id, user2Id, tempChat.getTempChatId());

            MatchDeliveryState deliveryState = MatchDeliveryState.builder()
                    .chatId(tempChat.getTempChatId())
                    .user1Id(user1Id)
                    .user2Id(user2Id)
                    .status(MatchDeliveryStatus.PENDING)
                    .createdAt(LocalDateTime.now())
                    .build();
            matchDeliveryStateRepository.save(deliveryState);

            log.info("Created match delivery state for chat {}: user1={}, user2={}",
                    tempChat.getTempChatId(), user1Id, user2Id);

            return convertToDto(tempChat);

        } catch (Exception e) {
            log.error("Error creating chat for pair", e);
            userRepository.findById(user1Id).ifPresent(u -> {
                u.setIsSearching(true);
                userRepository.save(u);
            });
            userRepository.findById(user2Id).ifPresent(u -> {
                u.setIsSearching(true);
                userRepository.save(u);
            });
            return null;
        }
    }

    @Scheduled(fixedDelay = 3000)
    @Transactional
    public void processSearchQueues() {
        log.debug("Processing search queues, total active searches: {}, waiting: {}",
                searchRequests.size(), waitingUsers.size());

        cleanupOldRequests();

        if (searchRequests.size() < 2) {
            return;
        }

        List<UUID> waitingCopy = new ArrayList<>(waitingUsers);

        waitingCopy.sort((id1, id2) -> {
            SearchRequest r1 = searchRequests.get(id1);
            SearchRequest r2 = searchRequests.get(id2);
            if (r1 == null || r2 == null)
                return 0;
            return r1.getAddedAt().compareTo(r2.getAddedAt());
        });

        for (int i = 0; i < waitingCopy.size() - 1; i++) {
            for (int j = i + 1; j < waitingCopy.size(); j++) {
                UUID user1Id = waitingCopy.get(i);
                UUID user2Id = waitingCopy.get(j);

                if (!searchRequests.containsKey(user1Id) || !searchRequests.containsKey(user2Id)) {
                    continue;
                }

                User user1 = userRepository.findById(user1Id).orElse(null);
                User user2 = userRepository.findById(user2Id).orElse(null);

                if (user1 == null || user2 == null) {
                    continue;
                }

                SearchFilters filters1 = searchRequests.get(user1Id).getFilters();
                SearchFilters filters2 = searchRequests.get(user2Id).getFilters();

                if (areUsersCompatible(user1, user2, filters1, filters2)) {
                    TemporaryChatDto chat = createChatForPair(user1Id, user2Id);
                    if (chat != null) {
                        matchedChatsCache.put(user1Id, chat.getTempChatId());
                        matchedChatsCache.put(user2Id, chat.getTempChatId());

                        removeFromSearch(user1Id);
                        removeFromSearch(user2Id);

                        log.info("Created chat for users {} and {} via scheduled task", user1Id, user2Id);
                        return;
                    }
                }
            }
        }
    }

    private Integer getQueuePosition(UUID userId) {
        if (!waitingUsers.contains(userId)) {
            return null;
        }

        int position = 1;
        for (UUID uid : waitingUsers) {
            if (uid.equals(userId)) {
                return position;
            }
            position++;
        }
        return null;
    }

    public SearchStatus getSearchStatus(UUID userId) {
        List<MatchDeliveryState> activeDeliveries = matchDeliveryStateRepository.findByUserIdAndStatus(
                userId, MatchDeliveryStatus.PENDING);

        if (activeDeliveries.isEmpty()) {
            activeDeliveries = matchDeliveryStateRepository.findByUserIdAndStatus(
                    userId, MatchDeliveryStatus.PARTIALLY_DELIVERED);
        }

        if (!activeDeliveries.isEmpty()) {
            MatchDeliveryState delivery = activeDeliveries.get(0);
            TemporaryChat chat = temporaryChatRepository
                    .findByTempChatId(delivery.getChatId())
                    .orElse(null);

            if (chat != null && !chat.getIsFinished()) {
                matchedChatsCache.put(userId, chat.getTempChatId());

                String matchStatus = "MATCH_FOUND";
                if (delivery.getStatus() == MatchDeliveryStatus.PARTIALLY_DELIVERED) {
                    matchStatus = "MATCH_FOUND";
                }

                return SearchStatus.builder()
                        .isSearching(false)
                        .searchingSince(null)
                        .filters(null)
                        .queuePosition(null)
                        .totalInQueue(null)
                        .matchedChat(convertToDto(chat))
                        .matchStatus(matchStatus)
                        .build();
            } else {
                matchDeliveryStateRepository.delete(delivery);
                matchedChatsCache.remove(userId);
            }
        }

        UUID cachedChatId = matchedChatsCache.get(userId);
        if (cachedChatId != null) {
            Optional<TemporaryChat> chatOpt = temporaryChatRepository.findByTempChatId(cachedChatId);
            if (chatOpt.isPresent() && !chatOpt.get().getIsFinished()) {
                Optional<MatchDeliveryState> deliveryOpt = matchDeliveryStateRepository
                        .findByChatId(cachedChatId);

                if (deliveryOpt.isPresent()) {
                    MatchDeliveryState delivery = deliveryOpt.get();
                    if (delivery.getStatus() != MatchDeliveryStatus.EXPIRED &&
                            delivery.getStatus() != MatchDeliveryStatus.CANCELLED) {

                        return SearchStatus.builder()
                                .isSearching(false)
                                .searchingSince(null)
                                .filters(null)
                                .queuePosition(null)
                                .totalInQueue(null)
                                .matchedChat(convertToDto(chatOpt.get()))
                                .matchStatus("MATCH_FOUND")
                                .build();
                    }
                }
            }
            matchedChatsCache.remove(userId);
        }

        boolean isSearching = searchRequests.containsKey(userId);
        SearchRequest request = searchRequests.get(userId);

        String matchStatus = "NO_MATCH";
        Integer queuePosition = null;
        Integer totalInQueue = null;

        if (request != null) {
            matchStatus = "SEARCHING";
            queuePosition = getQueuePosition(userId);
            totalInQueue = waitingUsers.size();
        }

        return SearchStatus.builder()
                .isSearching(isSearching)
                .searchingSince(request != null ? request.getAddedAt() : null)
                .filters(request != null ? request.getFilters() : null)
                .queuePosition(queuePosition)
                .totalInQueue(totalInQueue)
                .matchedChat(null)
                .matchStatus(matchStatus)
                .build();
    }

    private TemporaryChatDto convertToDto(TemporaryChat chat) {
        return TemporaryChatDto.builder()
                .tempChatId(chat.getTempChatId())
                .senderId(chat.getSender().getId())
                .recipientId(chat.getRecipient().getId())
                .createdAt(chat.getCreatedAt())
                .durationMinutes(chat.getDurationMinutes())
                .isFinished(chat.getIsFinished())
                .bothAgreed(chat.getBothAgreed())
                .build();
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

        cleanupOldChatsCache();
    }

    private void cleanupOldChatsCache() {
        Iterator<Map.Entry<UUID, UUID>> iterator = matchedChatsCache.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<UUID, UUID> entry = iterator.next();
            UUID chatId = entry.getValue();

            Optional<TemporaryChat> chatOpt = temporaryChatRepository.findByTempChatId(chatId);
            if (chatOpt.isEmpty() || chatOpt.get().getIsFinished()) {
                iterator.remove();
                log.debug("Removed stale chat from cache for user {}", entry.getKey());
            }
        }
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

        searchRequests.clear();
        waitingUsers.clear();
        matchedChatsCache.clear();

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

    public void removeChatFromCache(UUID chatId) {
        Set<UUID> usersToRemove = new HashSet<>();
        for (Map.Entry<UUID, UUID> entry : matchedChatsCache.entrySet()) {
            if (entry.getValue().equals(chatId)) {
                usersToRemove.add(entry.getKey());
            }
        }

        for (UUID userId : usersToRemove) {
            matchedChatsCache.remove(userId);
            log.debug("Removed chat {} from cache for user {}", chatId, userId);
        }
    }

    @Transactional
    public void acknowledgeTemporaryChat(UUID chatId, UUID userId) {
        Optional<TemporaryChat> chatOpt = temporaryChatRepository.findByTempChatId(chatId);
        if (chatOpt.isEmpty()) {
            throw new RuntimeException("Chat not found");
        }

        Optional<MatchDeliveryState> deliveryOpt = matchDeliveryStateRepository.findByChatId(chatId);
        if (deliveryOpt.isEmpty()) {
            throw new RuntimeException("Delivery state not found for chat");
        }

        MatchDeliveryState delivery = deliveryOpt.get();

        if (delivery.getStatus() == MatchDeliveryStatus.EXPIRED ||
                delivery.getStatus() == MatchDeliveryStatus.CANCELLED) {
            throw new RuntimeException("Match delivery has expired or cancelled");
        }

        boolean isUser1 = delivery.getUser1Id().equals(userId);
        boolean isUser2 = delivery.getUser2Id().equals(userId);

        if (!isUser1 && !isUser2) {
            throw new RuntimeException("User is not a participant of this match");
        }

        if (isUser1 && !delivery.isUser1Received()) {
            delivery.setUser1Received(true);
            delivery.setUser1AcknowledgedAt(LocalDateTime.now());
            log.info("User {} (user1) acknowledged chat {}", userId, chatId);
        } else if (isUser2 && !delivery.isUser2Received()) {
            delivery.setUser2Received(true);
            delivery.setUser2AcknowledgedAt(LocalDateTime.now());
            log.info("User {} (user2) acknowledged chat {}", userId, chatId);
        } else {
            log.debug("User {} already acknowledged chat {}", userId, chatId);
            return;
        }

        if (delivery.isUser1Received() && delivery.isUser2Received()) {
            delivery.setStatus(MatchDeliveryStatus.DELIVERED);
            delivery.setCompletedAt(LocalDateTime.now());

            log.info("Both users ACK chat {}. Status: DELIVERED", chatId);
        } else if (delivery.isUser1Received() || delivery.isUser2Received()) {
            delivery.setStatus(MatchDeliveryStatus.PARTIALLY_DELIVERED);
            log.info("Partially delivered chat {}. user1Received={}, user2Received={}",
                    chatId, delivery.isUser1Received(), delivery.isUser2Received());
        }

        matchDeliveryStateRepository.save(delivery);
    }

    public MatchDeliveryState getMatchDeliveryStatus(UUID chatId) {
        return matchDeliveryStateRepository.findByChatId(chatId)
                .orElseThrow(() -> new RuntimeException("Delivery state not found"));
    }

    public List<MatchDeliveryState> getPendingMatchesForUser(UUID userId) {
        List<MatchDeliveryState> allMatches = matchDeliveryStateRepository.findByUser1IdOrUser2Id(userId, userId);

        return allMatches.stream()
                .filter(match -> match.getStatus() == MatchDeliveryStatus.PENDING ||
                        match.getStatus() == MatchDeliveryStatus.PARTIALLY_DELIVERED)
                .collect(java.util.stream.Collectors.toList());
    }

    @Transactional
    public void cancelMatchDelivery(UUID chatId) {
        matchDeliveryStateRepository.findByChatId(chatId).ifPresent(delivery -> {
            delivery.setStatus(MatchDeliveryStatus.CANCELLED);
            matchDeliveryStateRepository.save(delivery);

            removeChatFromCache(chatId);
            log.info("Match delivery cancelled for chat {}", chatId);
        });
    }

    @Scheduled(fixedDelay = 10000)
    @Transactional
    public void cleanupUndeliveredMatches() {
        LocalDateTime cutoff = LocalDateTime.now().minusMinutes(5);

        List<MatchDeliveryStatus> expiredStatuses = Arrays.asList(
                MatchDeliveryStatus.PENDING,
                MatchDeliveryStatus.PARTIALLY_DELIVERED);

        List<MatchDeliveryState> expiredDeliveries = matchDeliveryStateRepository
                .findExpiredDeliveries(expiredStatuses, cutoff);

        for (MatchDeliveryState delivery : expiredDeliveries) {
            delivery.setStatus(MatchDeliveryStatus.EXPIRED);
            matchDeliveryStateRepository.save(delivery);

            removeChatFromCache(delivery.getChatId());

            log.warn("Match {} expired without full ACK. User1 received: {}, User2 received: {}",
                    delivery.getChatId(),
                    delivery.isUser1Received(),
                    delivery.isUser2Received());
        }

        if (!expiredDeliveries.isEmpty()) {
            log.info("Cleaned up {} expired match deliveries", expiredDeliveries.size());
        }
    }

    public int getActiveSearchCount() {
        return searchRequests.size();
    }

    public QueueStatsDto getQueueStats() {
        Map<String, Integer> genderCounts = new HashMap<>();
        for (SearchRequest request : searchRequests.values()) {
            String gender = request.getFilters().getFloor() != null ? request.getFilters().getFloor() : "any";
            genderCounts.put(gender, genderCounts.getOrDefault(gender, 0) + 1);
        }

        List<QueueSizeDto> queueSizes = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : genderCounts.entrySet()) {
            queueSizes.add(QueueSizeDto.builder()
                    .queueKey(entry.getKey())
                    .size(entry.getValue())
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
                .totalQueues(1)
                .queueSizes(queueSizes)
                .waitingTimes(waitingTimes)
                .build();
    }
}