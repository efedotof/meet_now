package com.efedotov.meet_now.meet_now.service.gift;

import com.efedotov.meet_now.meet_now.dto.request.gift.AdminCreateGiftRarityRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminCreateGiftRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminUpdateGiftRarityRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminUpdateGiftRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.SendGiftRequest;
import com.efedotov.meet_now.meet_now.dto.response.gift.*;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.gift.*;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.repository.gift.*;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class GiftService {

    private final GiftRepository giftRepository;
    private final SentGiftRepository sentGiftRepository;
    private final UserInventoryRepository userInventoryRepository;
    private final DailyGiftRepository dailyGiftRepository;
    private final GiftRarityRepository giftRarityRepository;
    private final UserRepository userRepository;
    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final GiftTypeRepository giftTypeRepository;

    @AdminOnly
    public List<AdminGiftDto> getAllGiftsAdmin() {
        return giftRepository.findAll().stream()
                .map(this::convertToAdminGiftDto)
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional
    public AdminGiftDto createGift(AdminCreateGiftRequest request) {
        GiftRarity rarity = giftRarityRepository.findById(request.getRarityId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Редкость не найдена"));

        GiftType giftType = findOrCreateGiftType(request.getGiftType());

        Gift gift = new Gift();
        gift.setName(request.getName());
        gift.setDescription(request.getDescription());
        gift.setImageUrl(request.getImageUrl());
        gift.setAnimationUrl(request.getAnimationUrl());
        gift.setGiftType(giftType);
        gift.setRarity(rarity);
        gift.setCostPoints(request.getCostPoints());
        gift.setIsActive(true);
        gift.setCreatedAt(LocalDateTime.now());

        Gift savedGift = giftRepository.save(gift);
        log.info("Создан новый подарок: {}", savedGift.getName());
        return convertToAdminGiftDto(savedGift);
    }

    @AdminOnly
    @Transactional
    public AdminGiftDto updateGift(UUID giftId, AdminUpdateGiftRequest request) {
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок не найден"));

        if (request.getName() != null) {
            gift.setName(request.getName());
        }
        if (request.getDescription() != null) {
            gift.setDescription(request.getDescription());
        }
        if (request.getImageUrl() != null) {
            gift.setImageUrl(request.getImageUrl());
        }
        if (request.getAnimationUrl() != null) {
            gift.setAnimationUrl(request.getAnimationUrl());
        }
        if (request.getGiftType() != null) {
            GiftType giftType = findOrCreateGiftType(request.getGiftType());
            gift.setGiftType(giftType);
        }
        if (request.getRarityId() != null) {
            GiftRarity rarity = giftRarityRepository.findById(request.getRarityId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Редкость не найдена"));
            gift.setRarity(rarity);
        }
        if (request.getCostPoints() != null) {
            gift.setCostPoints(request.getCostPoints());
        }
        if (request.getIsActive() != null) {
            gift.setIsActive(request.getIsActive());
        }

        Gift updatedGift = giftRepository.save(gift);
        log.info("Обновлен подарок: {}", updatedGift.getName());
        return convertToAdminGiftDto(updatedGift);
    }

    @AdminOnly
    private GiftType findOrCreateGiftType(String typeName) {
        Optional<GiftType> existingType = giftTypeRepository.findByTypeName(typeName);
        if (existingType.isPresent()) {
            return existingType.get();
        }

        GiftType newType = new GiftType();
        newType.setTypeName(typeName);
        newType.setDescription("Автоматически созданный тип: " + typeName);
        return giftTypeRepository.save(newType);
    }

    @AdminOnly
    @Transactional
    public void deleteGift(UUID giftId) {
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок не найден"));

        long sentGiftsCount = sentGiftRepository.countByGiftId(giftId);
        long inventoryCount = userInventoryRepository.countByGiftId(giftId);

        if (sentGiftsCount > 0 || inventoryCount > 0) {
            gift.setIsActive(false);
            giftRepository.save(gift);
            log.info("Подарок {} деактивирован (мягкое удаление)", gift.getName());
        } else {
            giftRepository.delete(gift);
            log.info("Подарок {} полностью удален", gift.getName());
        }
    }

    @AdminOnly
    @Transactional
    public AdminGiftDto toggleGiftActive(UUID giftId) {
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок не найден"));

        gift.setIsActive(!gift.getIsActive());
        Gift updatedGift = giftRepository.save(gift);

        log.info("Статус активности подарка {} изменен на: {}",
                updatedGift.getName(), updatedGift.getIsActive());
        return convertToAdminGiftDto(updatedGift);
    }

    @AdminOnly
    public List<AdminGiftRarityDto> getAllRaritiesAdmin() {
        return giftRarityRepository.findAll().stream()
                .map(this::convertToAdminGiftRarityDto)
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional
    public AdminGiftRarityDto createGiftRarity(AdminCreateGiftRarityRequest request) {
        if (giftRarityRepository.findByName(request.getName()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Редкость с таким именем уже существует");
        }

        GiftRarity rarity = new GiftRarity();
        rarity.setName(request.getName());
        rarity.setDisplayName(request.getDisplayName());
        rarity.setColor(request.getColor());
        rarity.setMultiplier(request.getMultiplier());
        rarity.setProbability(request.getProbability());
        rarity.setMinPoints(request.getMinPoints());
        rarity.setMaxPoints(request.getMaxPoints());
        rarity.setIsActive(true);
        rarity.setCreatedAt(LocalDateTime.now());

        GiftRarity savedRarity = giftRarityRepository.save(rarity);
        log.info("Создана новая редкость: {}", savedRarity.getName());
        return convertToAdminGiftRarityDto(savedRarity);
    }

    @AdminOnly
    @Transactional
    public AdminGiftRarityDto updateGiftRarity(UUID rarityId, AdminUpdateGiftRarityRequest request) {
        GiftRarity rarity = giftRarityRepository.findById(rarityId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Редкость не найдена"));

        if (request.getName() != null) {
            if (!rarity.getName().equals(request.getName()) &&
                    giftRarityRepository.findByName(request.getName()).isPresent()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Редкость с таким именем уже существует");
            }
            rarity.setName(request.getName());
        }
        if (request.getDisplayName() != null) {
            rarity.setDisplayName(request.getDisplayName());
        }
        if (request.getColor() != null) {
            rarity.setColor(request.getColor());
        }
        if (request.getMultiplier() != null) {
            rarity.setMultiplier(request.getMultiplier());
        }
        if (request.getProbability() != null) {
            rarity.setProbability(request.getProbability());
        }
        if (request.getMinPoints() != null) {
            rarity.setMinPoints(request.getMinPoints());
        }
        if (request.getMaxPoints() != null) {
            rarity.setMaxPoints(request.getMaxPoints());
        }
        if (request.getIsActive() != null) {
            rarity.setIsActive(request.getIsActive());
        }

        GiftRarity updatedRarity = giftRarityRepository.save(rarity);
        log.info("Обновлена редкость: {}", updatedRarity.getName());
        return convertToAdminGiftRarityDto(updatedRarity);
    }

    @AdminOnly
    @Transactional
    public void deleteGiftRarity(UUID rarityId) {
        GiftRarity rarity = giftRarityRepository.findById(rarityId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Редкость не найдена"));

        List<Gift> giftsWithRarity = giftRepository.findByRarity(rarity);
        if (!giftsWithRarity.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Невозможно удалить редкость, так как существуют подарки с этой редкостью");
        }

        giftRarityRepository.delete(rarity);
        log.info("Редкость {} удалена", rarity.getName());
    }

    @AdminOnly
    public AdminGiftStatsDto getAdminGiftStats() {
        long totalGifts = giftRepository.count();
        long activeGifts = giftRepository.countByIsActiveTrue();
        long totalRarities = giftRarityRepository.count();
        long activeRarities = giftRarityRepository.countByIsActiveTrue();
        long totalSentGifts = sentGiftRepository.count();
        long totalDailyGifts = dailyGiftRepository.count();
        long totalInventoryItems = userInventoryRepository.count();

        LocalDateTime weekAgo = LocalDateTime.now().minusDays(7);
        long sentGiftsLastWeek = sentGiftRepository.countBySentAtAfter(weekAgo);
        long dailyGiftsLastWeek = dailyGiftRepository.countByReceivedAtAfter(weekAgo);

        return AdminGiftStatsDto.builder()
                .totalGifts(totalGifts)
                .activeGifts(activeGifts)
                .totalRarities(totalRarities)
                .activeRarities(activeRarities)
                .totalSentGifts(totalSentGifts)
                .totalDailyGifts(totalDailyGifts)
                .totalInventoryItems(totalInventoryItems)
                .sentGiftsLastWeek(sentGiftsLastWeek)
                .dailyGiftsLastWeek(dailyGiftsLastWeek)
                .build();
    }

    @AdminOnly
    public List<AdminSentGiftDto> getSentGiftsAdmin(int page, int size) {
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "sentAt"));
        return sentGiftRepository.findAll(pageRequest).getContent().stream()
                .map(this::convertToAdminSentGiftDto)
                .collect(Collectors.toList());
    }

    @AdminOnly
    public List<AdminUserInventoryDto> getUserInventoryAdmin(UUID userId) {
        List<UserInventory> inventory = userInventoryRepository.findByUserId(userId);
        return inventory.stream()
                .map(this::convertToAdminUserInventoryDto)
                .collect(Collectors.toList());
    }

    @AdminOnly
    public AdminUserGiftStatsDto getUserGiftStatsAdmin(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователь не найден"));

        long sentCount = sentGiftRepository.countBySenderId(userId);
        long receivedCount = sentGiftRepository.countByRecipientId(userId);
        long inventoryCount = userInventoryRepository.countByUserId(userId);

        Integer currentStreak = getCurrentStreak(userId);
        Integer maxStreak = getMaxStreak(userId);

        long dailyGiftsCount = dailyGiftRepository.countByUserId(userId);

        List<Object[]> popularSentGifts = sentGiftRepository.findPopularSentGiftsByUser(userId);
        UUID mostPopularSentGiftId = popularSentGifts.isEmpty() ? null : (UUID) popularSentGifts.get(0)[0];
        long mostPopularSentGiftCount = popularSentGifts.isEmpty() ? 0L : (Long) popularSentGifts.get(0)[1];

        List<Object[]> popularReceivedGifts = sentGiftRepository.findPopularReceivedGiftsByUser(userId);
        UUID mostPopularReceivedGiftId = popularReceivedGifts.isEmpty() ? null : (UUID) popularReceivedGifts.get(0)[0];
        long mostPopularReceivedGiftCount = popularReceivedGifts.isEmpty() ? 0L : (Long) popularReceivedGifts.get(0)[1];

        return AdminUserGiftStatsDto.builder()
                .userId(userId)
                .username(user.getUsername())
                .sentCount(sentCount)
                .receivedCount(receivedCount)
                .inventoryCount(inventoryCount)
                .currentStreak(currentStreak)
                .maxStreak(maxStreak)
                .dailyGiftsCount(dailyGiftsCount)
                .mostPopularSentGiftId(mostPopularSentGiftId)
                .mostPopularSentGiftCount(mostPopularSentGiftCount)
                .mostPopularReceivedGiftId(mostPopularReceivedGiftId)
                .mostPopularReceivedGiftCount(mostPopularReceivedGiftCount)
                .build();
    }

    public List<GiftDto> getAllAvailableGifts() {
        return giftRepository.findByIsActiveTrue().stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    public List<GiftDto> getGiftsByType(String typeName) {
        return giftRepository.findByGiftTypeTypeNameAndIsActiveTrue(typeName).stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    public List<GiftDto> getGiftsByRarity(String rarityName) {
        GiftRarity rarity = giftRarityRepository.findByName(rarityName)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Редкость не найдена"));

        return giftRepository.findByRarityAndIsActiveTrue(rarity).stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    public List<GiftRarityDto> getAllRarities() {
        return giftRarityRepository.findByIsActiveTrue().stream()
                .map(this::convertToGiftRarityDto)
                .collect(Collectors.toList());
    }

    public GiftRarityDto getRarityByName(String name) {
        GiftRarity rarity = giftRarityRepository.findByName(name)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Редкость не найдена"));
        return convertToGiftRarityDto(rarity);
    }

    public List<GiftDto> getGiftsByCostRange(Integer minCost, Integer maxCost) {
        if (minCost == null)
            minCost = 0;
        if (maxCost == null)
            maxCost = Integer.MAX_VALUE;

        if (minCost < 0 || maxCost < 0 || minCost > maxCost) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Неверный диапазон стоимости");
        }

        return giftRepository.findByCostRange(minCost, maxCost).stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public SentGiftDto sendGift(UUID senderId, SendGiftRequest request) {
        if (senderId.equals(request.getRecipientId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Нельзя отправить подарок самому себе");
        }

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователь не найден"));

        User recipient = userRepository.findById(request.getRecipientId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Получатель не найден"));

        Gift gift = giftRepository.findById(request.getGiftId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок не найден"));

        if (!gift.getIsActive()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок неактивен");
        }

        if (sender.getGamePoints() < gift.getCostPoints()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Недостаточно игровых очков. Требуется: " + gift.getCostPoints() + ", доступно: "
                            + sender.getGamePoints());
        }

        sender.setGamePoints(sender.getGamePoints() - gift.getCostPoints());
        userRepository.save(sender);

        SentGift sentGift = new SentGift();
        sentGift.setSender(sender);
        sentGift.setRecipient(recipient);
        sentGift.setGift(gift);
        sentGift.setMessage(Optional.ofNullable(request.getMessage()).orElse(""));
        sentGift.setIsAnonymous(Boolean.TRUE.equals(request.getIsAnonymous()));
        sentGift.setSentAt(LocalDateTime.now());

        if (request.getChatId() != null) {
            Chat chat = chatRepository.findById(request.getChatId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Чат не найден"));
            sentGift.setChat(chat);
        } else if (request.getTempChatId() != null) {
            TemporaryChat tempChat = temporaryChatRepository.findById(request.getTempChatId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Временный чат не найден"));
            sentGift.setTempChat(tempChat);
        }

        SentGift savedSentGift = sentGiftRepository.save(sentGift);

        addGiftToInventory(recipient, gift, sender, Boolean.TRUE.equals(request.getIsAnonymous()));

        log.info("Подарок '{}' отправлен от {} к {}", gift.getName(), senderId, request.getRecipientId());
        return convertToSentGiftDto(savedSentGift);
    }

    private void addGiftToInventory(User recipient, Gift gift, User sender, Boolean isAnonymous) {
        User receivedFrom = Boolean.TRUE.equals(isAnonymous) ? null : sender;

        Optional<UserInventory> existingInventory = userInventoryRepository
                .findByUserIdAndGiftId(recipient.getId(), gift.getId())
                .filter(inventory -> {
                    if (receivedFrom == null) {
                        return inventory.getReceivedFrom() == null;
                    } else {
                        return receivedFrom.equals(inventory.getReceivedFrom());
                    }
                });

        if (existingInventory.isPresent()) {
            UserInventory inventory = existingInventory.get();
            inventory.setQuantity(inventory.getQuantity() + 1);
            userInventoryRepository.save(inventory);
        } else {
            UserInventory inventory = new UserInventory();
            inventory.setUser(recipient);
            inventory.setGift(gift);
            inventory.setReceivedFrom(receivedFrom);
            inventory.setQuantity(1);
            inventory.setIsVisible(true);
            inventory.setReceivedAt(LocalDateTime.now());
            userInventoryRepository.save(inventory);
        }
    }

    public List<SentGiftDto> getSentGifts(UUID userId, int limit) {
        PageRequest pageRequest = PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "sentAt"));
        return sentGiftRepository.findBySenderIdOrderBySentAtDesc(userId, pageRequest).getContent().stream()
                .map(this::convertToSentGiftDto)
                .collect(Collectors.toList());
    }

    public List<SentGiftDto> getReceivedGifts(UUID userId, int limit) {
        PageRequest pageRequest = PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "sentAt"));
        return sentGiftRepository.findByRecipientIdOrderBySentAtDesc(userId, pageRequest).getContent().stream()
                .map(this::convertToSentGiftDto)
                .collect(Collectors.toList());
    }

    public List<UserInventoryDto> getUserInventory(UUID userId) {
        List<UserInventory> inventory = userInventoryRepository.findByUserIdAndIsVisibleTrue(userId);
        return inventory.stream()
                .map(this::convertToUserInventoryDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public GiftDto claimDailyGift(UUID userId) {
        log.info("🎁 Попытка получения ежедневного подарка для пользователя: {}", userId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> {
                    log.error("Пользователь не найден: {}", userId);
                    return new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователь не найден");
                });

        Optional<DailyGift> todayGift = dailyGiftRepository.findTodayByUserId(userId);
        if (todayGift.isPresent()) {
            log.warn("Пользователь {} уже получил подарок сегодня", userId);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Вы уже получили ежедневный подарок сегодня");
        }

        Gift dailyGift = getRandomDailyGift();
        if (dailyGift == null) {
            log.error("Нет доступных подарков в системе");
            throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
                    "В настоящее время нет доступных подарков. Пожалуйста, попробуйте позже.");
        }

        int streakCount = calculateCurrentStreak(userId);

        DailyGift newDailyGift = new DailyGift();
        newDailyGift.setUser(user);
        newDailyGift.setGift(dailyGift);
        newDailyGift.setStreakCount(streakCount);
        newDailyGift.setReceivedAt(LocalDateTime.now());
        dailyGiftRepository.save(newDailyGift);

        addGiftToInventory(user, dailyGift, null, false);

        log.info("Ежедневный подарок '{}' выдан пользователю {}, серия: {}",
                dailyGift.getName(), userId, streakCount);
        return convertToGiftDto(dailyGift);
    }

    private Gift getRandomDailyGift() {
        List<GiftRarity> activeRarities = giftRarityRepository.findActiveByProbability();
        log.info("Найдено активных редкостей: {}", activeRarities.size());

        if (activeRarities.isEmpty()) {
            log.error("Нет активных редкостей подарков");
            return null;
        }

        List<GiftRarity> raritiesWithGifts = new ArrayList<>();
        Map<GiftRarity, List<Gift>> giftsByRarity = new HashMap<>();

        for (GiftRarity rarity : activeRarities) {
            List<Gift> gifts = giftRepository.findByRarityAndIsActiveTrue(rarity);
            if (!gifts.isEmpty()) {
                raritiesWithGifts.add(rarity);
                giftsByRarity.put(rarity, gifts);
                log.info("Для редкости {} найдено подарков: {}", rarity.getName(), gifts.size());
            } else {
                log.warn("Для редкости {} нет активных подарков", rarity.getName());
            }
        }

        if (raritiesWithGifts.isEmpty()) {
            log.error("Нет активных подарков ни для одной редкости");
            return null;
        }

        double totalProbability = raritiesWithGifts.stream()
                .mapToDouble(GiftRarity::getProbability)
                .sum();

        log.info("Общая вероятность для редкостей с подарками: {}", totalProbability);

        if (totalProbability <= 0) {
            log.error("Общая вероятность редкостей с подарками <= 0");
            return null;
        }

        double randomValue = Math.random() * totalProbability;
        double cumulativeProbability = 0.0;
        GiftRarity selectedRarity = null;

        for (GiftRarity rarity : raritiesWithGifts) {
            cumulativeProbability += rarity.getProbability();
            if (randomValue <= cumulativeProbability) {
                selectedRarity = rarity;
                break;
            }
        }

        if (selectedRarity == null && !raritiesWithGifts.isEmpty()) {
            selectedRarity = raritiesWithGifts.get(0);
        }

        if (selectedRarity == null) {
            log.error("Не удалось выбрать редкость");
            return null;
        }

        log.info("🎲 Выбрана редкость: {}", selectedRarity.getName());

        List<Gift> gifts = giftsByRarity.get(selectedRarity);
        log.info("Найдено подарков для редкости {}: {}", selectedRarity.getName(), gifts.size());

        if (gifts.isEmpty()) {
            log.error("Нет активных подарков для выбранной редкости: {}", selectedRarity.getName());
            return null;
        }

        Gift selectedGift = gifts.get((int) (Math.random() * gifts.size()));
        log.info("Выбран подарок: {}", selectedGift.getName());

        return selectedGift;
    }

    private int calculateCurrentStreak(UUID userId) {
        int streakCount = 1;
        Optional<DailyGift> lastGift = dailyGiftRepository.findLatestByUserId(userId);
        if (lastGift.isPresent()) {
            LocalDate lastGiftDate = lastGift.get().getReceivedAt().toLocalDate();
            if (lastGiftDate.equals(LocalDate.now().minusDays(1))) {
                streakCount = lastGift.get().getStreakCount() + 1;
            } else if (!lastGiftDate.equals(LocalDate.now())) {
                streakCount = 1;
            }
        }
        return streakCount;
    }

    public boolean isDailyGiftAvailable(UUID userId) {
        return dailyGiftRepository.findTodayByUserId(userId).isEmpty();
    }

    public Integer getCurrentStreak(UUID userId) {
        return dailyGiftRepository.findLatestByUserId(userId)
                .map(DailyGift::getStreakCount)
                .orElse(0);
    }

    public Integer getMaxStreak(UUID userId) {
        Integer maxStreak = dailyGiftRepository.findMaxStreakByUserId(userId);
        return maxStreak != null ? maxStreak : 0;
    }

    public GiftStatsDto getGiftStats(UUID userId) {
        Long sentCountRaw = sentGiftRepository.countBySenderId(userId);
        long sentCount = sentCountRaw != null ? sentCountRaw : 0L;

        Long receivedCountRaw = sentGiftRepository.countByRecipientId(userId);
        long receivedCount = receivedCountRaw != null ? receivedCountRaw : 0L;

        Long inventoryCountRaw = userInventoryRepository.countByUserId(userId);
        long inventoryCount = inventoryCountRaw != null ? inventoryCountRaw : 0L;

        Integer currentStreak = getCurrentStreak(userId);
        Integer maxStreak = getMaxStreak(userId);

        return GiftStatsDto.builder()
                .sentCount(sentCount)
                .receivedCount(receivedCount)
                .inventoryCount(inventoryCount)
                .currentStreak(currentStreak)
                .maxStreak(maxStreak)
                .build();
    }

    private GiftDto convertToGiftDto(Gift gift) {
        return GiftDto.builder()
                .id(gift.getId())
                .name(gift.getName())
                .description(gift.getDescription())
                .imageUrl(gift.getImageUrl())
                .giftType(gift.getGiftType().getTypeName())
                .rarity(convertToGiftRarityDto(gift.getRarity()))
                .costPoints(gift.getCostPoints())
                .animationUrl(gift.getAnimationUrl())
                .build();
    }

    @AdminOnly
    private AdminGiftDto convertToAdminGiftDto(Gift gift) {
        return AdminGiftDto.builder()
                .id(gift.getId())
                .name(gift.getName())
                .description(gift.getDescription())
                .imageUrl(gift.getImageUrl())
                .giftType(gift.getGiftType().getTypeName())
                .rarity(convertToGiftRarityDto(gift.getRarity()))
                .costPoints(gift.getCostPoints())
                .animationUrl(gift.getAnimationUrl())
                .isActive(gift.getIsActive())
                .createdAt(gift.getCreatedAt())
                .build();
    }

    private GiftRarityDto convertToGiftRarityDto(GiftRarity rarity) {
        if (rarity == null) {
            return null;
        }
        return GiftRarityDto.builder()
                .id(rarity.getId())
                .name(rarity.getName())
                .displayName(rarity.getDisplayName())
                .color(rarity.getColor())
                .multiplier(rarity.getMultiplier())
                .probability(rarity.getProbability())
                .minPoints(rarity.getMinPoints())
                .maxPoints(rarity.getMaxPoints())
                .isActive(rarity.getIsActive())
                .build();
    }

    @AdminOnly
    private AdminGiftRarityDto convertToAdminGiftRarityDto(GiftRarity rarity) {
        if (rarity == null) {
            return null;
        }
        return AdminGiftRarityDto.builder()
                .id(rarity.getId())
                .name(rarity.getName())
                .displayName(rarity.getDisplayName())
                .color(rarity.getColor())
                .multiplier(rarity.getMultiplier())
                .probability(rarity.getProbability())
                .minPoints(rarity.getMinPoints())
                .maxPoints(rarity.getMaxPoints())
                .isActive(rarity.getIsActive())
                .createdAt(rarity.getCreatedAt())
                .build();
    }

    private SentGiftDto convertToSentGiftDto(SentGift sentGift) {
        return SentGiftDto.builder()
                .id(sentGift.getId())
                .senderId(sentGift.getSender().getId())
                .recipientId(sentGift.getRecipient().getId())
                .gift(convertToGiftDto(sentGift.getGift()))
                .chatId(sentGift.getChat() != null ? sentGift.getChat().getChatId() : null)
                .tempChatId(sentGift.getTempChat() != null ? sentGift.getTempChat().getTempChatId() : null)
                .message(sentGift.getMessage())
                .isAnonymous(sentGift.getIsAnonymous())
                .sentAt(sentGift.getSentAt())
                .build();
    }

    @AdminOnly
    private AdminSentGiftDto convertToAdminSentGiftDto(SentGift sentGift) {
        return AdminSentGiftDto.builder()
                .id(sentGift.getId())
                .senderId(sentGift.getSender().getId())
                .senderUsername(sentGift.getSender().getUsername())
                .recipientId(sentGift.getRecipient().getId())
                .recipientUsername(sentGift.getRecipient().getUsername())
                .gift(convertToAdminGiftDto(sentGift.getGift()))
                .chatId(sentGift.getChat() != null ? sentGift.getChat().getChatId() : null)
                .tempChatId(sentGift.getTempChat() != null ? sentGift.getTempChat().getTempChatId() : null)
                .message(sentGift.getMessage())
                .isAnonymous(sentGift.getIsAnonymous())
                .sentAt(sentGift.getSentAt())
                .build();
    }

    private UserInventoryDto convertToUserInventoryDto(UserInventory userInventory) {
        return UserInventoryDto.builder()
                .id(userInventory.getId())
                .gift(convertToGiftDto(userInventory.getGift()))
                .receivedFromId(
                        userInventory.getReceivedFrom() != null ? userInventory.getReceivedFrom().getId() : null)
                .quantity(userInventory.getQuantity())
                .isVisible(userInventory.getIsVisible())
                .receivedAt(userInventory.getReceivedAt())
                .build();
    }

    @AdminOnly
    private AdminUserInventoryDto convertToAdminUserInventoryDto(UserInventory userInventory) {
        return AdminUserInventoryDto.builder()
                .id(userInventory.getId())
                .userId(userInventory.getUser().getId())
                .username(userInventory.getUser().getUsername())
                .gift(convertToAdminGiftDto(userInventory.getGift()))
                .receivedFromId(
                        userInventory.getReceivedFrom() != null ? userInventory.getReceivedFrom().getId() : null)
                .receivedFromUsername(
                        userInventory.getReceivedFrom() != null ? userInventory.getReceivedFrom().getUsername() : null)
                .quantity(userInventory.getQuantity())
                .isVisible(userInventory.getIsVisible())
                .receivedAt(userInventory.getReceivedAt())
                .build();
    }
}