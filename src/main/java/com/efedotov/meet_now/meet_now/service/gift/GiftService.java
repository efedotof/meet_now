package com.efedotov.meet_now.meet_now.service.gift;

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
        Long sentCount = sentGiftRepository.countBySenderId(userId);
        Long receivedCount = sentGiftRepository.countByRecipientId(userId);
        Long inventoryCount = userInventoryRepository.countByUserId(userId);
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
}