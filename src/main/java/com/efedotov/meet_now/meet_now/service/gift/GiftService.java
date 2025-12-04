package com.efedotov.meet_now.meet_now.service.gift;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.request.gift.AdminCreateGiftRarityRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminCreateGiftRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminUpdateGiftRarityRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.AdminUpdateGiftRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.BuyGiftForSelfRequest;
import com.efedotov.meet_now.meet_now.dto.request.gift.SendGiftRequest;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminGiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminGiftRarityDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminGiftStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminSentGiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminUserGiftStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.AdminUserInventoryDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.BuyGiftResponse;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftRarityDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.GiftTypeDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.SentGiftDto;
import com.efedotov.meet_now.meet_now.dto.response.gift.UserInventoryDto;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.gift.DailyGift;
import com.efedotov.meet_now.meet_now.model.gift.Gift;
import com.efedotov.meet_now.meet_now.model.gift.GiftRarity;
import com.efedotov.meet_now.meet_now.model.gift.GiftType;
import com.efedotov.meet_now.meet_now.model.gift.SentGift;
import com.efedotov.meet_now.meet_now.model.gift.UserInventory;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.repository.gift.DailyGiftRepository;
import com.efedotov.meet_now.meet_now.repository.gift.GiftRarityRepository;
import com.efedotov.meet_now.meet_now.repository.gift.GiftRepository;
import com.efedotov.meet_now.meet_now.repository.gift.GiftTypeRepository;
import com.efedotov.meet_now.meet_now.repository.gift.SentGiftRepository;
import com.efedotov.meet_now.meet_now.repository.gift.UserInventoryRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

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

        gift.setIsLimited(Boolean.TRUE.equals(request.getIsLimited()));
        if (Boolean.TRUE.equals(request.getIsLimited())) {
            gift.setAvailableQuantity(request.getAvailableQuantity());
            gift.setInitialQuantity(request.getInitialQuantity() != null ? request.getInitialQuantity()
                    : request.getAvailableQuantity());
            gift.setIsSoldOut(request.getAvailableQuantity() != null && request.getAvailableQuantity() <= 0);
        }

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

        if (request.getIsLimited() != null) {
            gift.setIsLimited(request.getIsLimited());
        }
        if (request.getAvailableQuantity() != null) {
            gift.setAvailableQuantity(request.getAvailableQuantity());
        }
        if (request.getInitialQuantity() != null) {
            gift.setInitialQuantity(request.getInitialQuantity());
        }
        if (request.getSoldCount() != null) {
            gift.setSoldCount(request.getSoldCount());
        }
        if (request.getIsSoldOut() != null) {
            gift.setIsSoldOut(request.getIsSoldOut());
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

        long limitedGifts = giftRepository.findAll().stream()
                .filter(Gift::getIsLimited)
                .count();
        long availableLimitedGifts = giftRepository.countAvailableLimitedGifts();
        long soldOutGifts = giftRepository.findAll().stream()
                .filter(g -> Boolean.TRUE.equals(g.getIsLimited()) && Boolean.TRUE.equals(g.getIsSoldOut()))
                .count();

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
                .limitedGifts(limitedGifts)
                .availableLimitedGifts(availableLimitedGifts)
                .soldOutGifts(soldOutGifts)
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

        int currentStreak = getCurrentStreak(userId) != null ? getCurrentStreak(userId) : 0;
        int maxStreak = getMaxStreak(userId) != null ? getMaxStreak(userId) : 0;

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
        return giftRepository.findAvailableForPurchase().stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    public List<GiftDto> getGiftsByType(String typeName) {
        return giftRepository.findByGiftTypeTypeNameAndIsActiveTrue(typeName).stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    public List<GiftTypeDto> getAllGiftTypes() {
        List<GiftType> giftTypes = giftTypeRepository.findAllByOrderByTypeNameAsc();

        return giftTypes.stream()
                .map(this::convertToDto)
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
        log.info("Попытка отправки подарка от {} к {}", senderId, request.getRecipientId());

        if (senderId.equals(request.getRecipientId())) {
            log.error("Пользователь {} пытается отправить подарок самому себе", senderId);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Нельзя отправить подарок самому себе");
        }

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> {
                    log.error("Отправитель не найден: {}", senderId);
                    return new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователь не найден");
                });

        User recipient = userRepository.findById(request.getRecipientId())
                .orElseThrow(() -> {
                    log.error("Получатель не найден: {}", request.getRecipientId());
                    return new ResponseStatusException(HttpStatus.NOT_FOUND, "Получатель не найден");
                });

        Gift gift = giftRepository.findById(request.getGiftId())
                .orElseThrow(() -> {
                    log.error("Подарок не найден: {}", request.getGiftId());
                    return new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок не найден");
                });

        if (!gift.getIsActive()) {
            log.error("Подарок неактивен: {}", gift.getName());
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Подарок недоступен для отправки");
        }

        if (Boolean.TRUE.equals(gift.getIsLimited())) {
            if (Boolean.TRUE.equals(gift.getIsSoldOut())) {
                log.error("Лимитированный подарок распродан: {}", gift.getName());
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Этот подарок уже распродан");
            }

            if (gift.getAvailableQuantity() != null && gift.getAvailableQuantity() <= 0) {
                log.error("Лимитированный подарок закончился: {}", gift.getName());
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Этот подарок закончился");
            }
        }

        if (sender.getGamePoints() < gift.getCostPoints()) {
            log.error("Недостаточно очков у пользователя {}. Требуется: {}, доступно: {}",
                    senderId, gift.getCostPoints(), sender.getGamePoints());
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    String.format("Недостаточно игровых очков. Требуется: %d, доступно: %d",
                            gift.getCostPoints(), sender.getGamePoints()));
        }

        if (Boolean.TRUE.equals(gift.getIsLimited())) {
            int updated = giftRepository.decreaseGiftQuantity(gift.getId(), 1);
            if (updated == 0) {
                log.error("Не удалось зарезервировать лимитированный подарок {} для пользователя {}",
                        gift.getName(), senderId);
                throw new ResponseStatusException(HttpStatus.CONFLICT,
                        "Не удалось зарезервировать подарок. Возможно, он уже закончился");
            }
            log.info("Количество лимитированного подарка '{}' уменьшено. Осталось: {}",
                    gift.getName(), gift.getAvailableQuantity() != null ? gift.getAvailableQuantity() - 1 : "∞");
        }

        Integer newBalance = sender.getGamePoints() - gift.getCostPoints();
        sender.setGamePoints(newBalance);

        userRepository.save(sender);

        log.info("Списано {} очков у отправителя {}. Новый баланс: {}",
                gift.getCostPoints(), senderId, newBalance);

        Chat chat = null;
        if (request.getChatId() != null) {
            chat = chatRepository.findById(request.getChatId())
                    .orElseThrow(() -> {
                        log.warn("Чат не найден: {}", request.getChatId());
                        return new ResponseStatusException(HttpStatus.NOT_FOUND, "Чат не найден");
                    });

            boolean hasAccess = chatRepository.existsByChatIdAndUserId(chat.getChatId(), senderId);
            if (!hasAccess) {
                log.error("Пользователь {} не имеет доступа к чату {}", senderId, request.getChatId());
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "У вас нет доступа к этому чату");
            }
        }

        TemporaryChat tempChat = null;
        if (request.getTempChatId() != null) {
            tempChat = temporaryChatRepository.findById(request.getTempChatId())
                    .orElseThrow(() -> {
                        log.warn("Временный чат не найден: {}", request.getTempChatId());
                        return new ResponseStatusException(HttpStatus.NOT_FOUND, "Временный чат не найден");
                    });

            boolean hasAccess = temporaryChatRepository.existsByTempChatIdAndUserId(
                    tempChat.getTempChatId(), senderId);
            if (!hasAccess) {
                log.error("Пользователь {} не имеет доступа к временному чату {}", senderId, request.getTempChatId());
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "У вас нет доступа к этому временному чату");
            }
        }

        if (chat != null && tempChat != null) {
            log.error("Указаны и чат, и временный чат одновременно");
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Можно указать только один тип чата: обычный или временный");
        }

        SentGift sentGift = new SentGift();
        sentGift.setSender(sender);
        sentGift.setRecipient(recipient);
        sentGift.setGift(gift);
        sentGift.setMessage(Optional.ofNullable(request.getMessage()).orElse(""));
        sentGift.setIsAnonymous(Boolean.TRUE.equals(request.getIsAnonymous()));
        sentGift.setSentAt(LocalDateTime.now());

        if (chat != null) {
            sentGift.setChat(chat);
        }

        if (tempChat != null) {
            sentGift.setTempChat(tempChat);
        }

        SentGift savedSentGift = sentGiftRepository.save(sentGift);

        log.info("Создана запись об отправленном подарке: ID {}", savedSentGift.getId());

        addGiftToInventory(recipient, gift,
                Boolean.TRUE.equals(request.getIsAnonymous()) ? null : sender,
                Boolean.TRUE.equals(request.getIsAnonymous()));

        log.info("Подарок '{}' добавлен в инвентарь получателя {}",
                gift.getName(), recipient.getId());

        updateGiftStatistics(sender, recipient, gift);

        log.info("Подарок '{}' (стоимостью {} очков) успешно отправлен от {} к {}. Анонимно: {}",
                gift.getName(), gift.getCostPoints(), senderId, request.getRecipientId(),
                Boolean.TRUE.equals(request.getIsAnonymous()));

        return convertToSentGiftDto(savedSentGift);
    }

    private void updateGiftStatistics(User sender, User recipient, Gift gift) {
        log.debug("Обновление статистики для подарка '{}' от {} к {}",
                gift.getName(), sender.getId(), recipient.getId());

    }

    @Transactional
    public BuyGiftResponse buyGiftForSelf(UUID userId, BuyGiftForSelfRequest request) {
        log.info("Пользователь {} пытается купить подарок для себя: {}", userId, request.getGiftId());

        User user = userRepository.findById(userId)
                .orElseThrow(() -> {
                    log.error("Пользователь не найден: {}", userId);
                    return new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователь не найден");
                });

        Gift gift = giftRepository.findById(request.getGiftId())
                .orElseThrow(() -> {
                    log.error("Подарок не найден: {}", request.getGiftId());
                    return new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок не найден");
                });

        if (!gift.getIsActive()) {
            log.error("Подарок неактивен: {}", request.getGiftId());
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Подарок недоступен для покупки");
        }

        if (Boolean.TRUE.equals(gift.getIsLimited())) {
            if (Boolean.TRUE.equals(gift.getIsSoldOut())) {
                log.error("Подарок распродан: {}", gift.getName());
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Этот подарок уже распродан");
            }

            if (gift.getAvailableQuantity() != null && gift.getAvailableQuantity() <= 0) {
                log.error("Подарок закончился: {}", gift.getName());
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Этот подарок закончился");
            }
        }

        Integer giftCost = gift.getCostPoints();
        if (giftCost == null || giftCost <= 0) {
            log.error("Подарок {} имеет невалидную стоимость: {}", gift.getName(), giftCost);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Подарок не может быть куплен");
        }

        Integer userPoints = user.getGamePoints();
        if (userPoints < giftCost) {
            log.error("Недостаточно очков у пользователя {}. Требуется: {}, доступно: {}",
                    userId, giftCost, userPoints);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    String.format("Недостаточно игровых очков. Требуется: %d, доступно: %d",
                            giftCost, userPoints));
        }

        if (Boolean.TRUE.equals(gift.getIsLimited())) {
            int updated = giftRepository.decreaseGiftQuantity(gift.getId(), 1);
            if (updated == 0) {
                log.error("Не удалось зарезервировать подарок: {}", gift.getName());
                throw new ResponseStatusException(HttpStatus.CONFLICT,
                        "Не удалось зарезервировать подарок. Возможно, он уже закончился");
            }
            log.info("Количество подарка {} уменьшено. Осталось: {}",
                    gift.getName(), gift.getAvailableQuantity() != null ? gift.getAvailableQuantity() - 1 : "∞");
        }

        Integer newBalance = userPoints - giftCost;
        user.setGamePoints(newBalance);
        User savedUser = userRepository.save(user);

        log.info("Списано {} очков у пользователя {}. Новый баланс: {}",
                giftCost, userId, newBalance);

        UserInventory inventoryItem = addGiftToInventory(user, gift, null, false);

        log.info("Подарок '{}' успешно куплен пользователем {}", gift.getName(), userId);

        UUID purchaseId = UUID.randomUUID();

        return BuyGiftResponse.builder()
                .purchaseId(purchaseId)
                .inventoryItem(convertToUserInventoryDto(inventoryItem))
                .spentPoints(giftCost)
                .newBalance(savedUser.getGamePoints())
                .purchasedAt(LocalDateTime.now())
                .build();
    }

    private UserInventory addGiftToInventory(User recipient, Gift gift, User sender, Boolean isAnonymous) {
        User receivedFrom = Boolean.TRUE.equals(isAnonymous) ? null : sender;

        Optional<UserInventory> existingInventory = userInventoryRepository
                .findByUserIdAndGiftId(recipient.getId(), gift.getId())
                .filter(inventory -> {
                    if (receivedFrom == null) {
                        return inventory.getReceivedFrom() == null;
                    } else {
                        return receivedFrom != null && receivedFrom.equals(inventory.getReceivedFrom());
                    }
                });

        if (existingInventory.isPresent()) {
            UserInventory inventory = existingInventory.get();
            inventory.setQuantity(inventory.getQuantity() + 1);
            inventory.setReceivedAt(LocalDateTime.now());
            return userInventoryRepository.save(inventory);
        } else {
            UserInventory inventory = new UserInventory();
            inventory.setUser(recipient);
            inventory.setGift(gift);
            inventory.setReceivedFrom(receivedFrom);
            inventory.setQuantity(1);
            inventory.setIsVisible(true);
            inventory.setReceivedAt(LocalDateTime.now());
            return userInventoryRepository.save(inventory);
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

        int currentStreak = getCurrentStreak(userId) != null ? getCurrentStreak(userId) : 0;
        int maxStreak = getMaxStreak(userId) != null ? getMaxStreak(userId) : 0;

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

                .availableQuantity(gift.getAvailableQuantity())
                .isLimited(gift.getIsLimited())
                .isSoldOut(gift.getIsSoldOut())
                .soldCount(gift.getSoldCount())
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
                .availableQuantity(gift.getAvailableQuantity())
                .isLimited(gift.getIsLimited())
                .isSoldOut(gift.getIsSoldOut())
                .initialQuantity(gift.getInitialQuantity())
                .soldCount(gift.getSoldCount())
                .build();
    }

    private GiftRarityDto convertToGiftRarityDto(GiftRarity rarity) {
        if (rarity == null) {
            log.warn("Attempt to convert null GiftRarity to DTO");
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

    private GiftTypeDto convertToDto(GiftType giftType) {
        return GiftTypeDto.builder()
                .id(giftType.getId())
                .typeName(giftType.getTypeName())
                .description(giftType.getDescription())
                .build();
    }

    public List<GiftDto> getAvailableLimitedGifts() {
        return giftRepository.findLimitedAvailableGifts().stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    public List<GiftDto> getSoldOutGifts() {
        return giftRepository.findSoldOutGifts().stream()
                .map(this::convertToGiftDto)
                .collect(Collectors.toList());
    }

    public boolean checkGiftAvailability(UUID giftId) {
        try {
            Gift gift = giftRepository.findById(giftId)
                    .orElseThrow(() -> {
                        log.warn("Подарок с ID {} не найден", giftId);
                        return new ResponseStatusException(HttpStatus.NOT_FOUND, "Подарок не найден");
                    });

            boolean isAvailable = gift.isAvailableForPurchase();

            if (!isAvailable) {
                log.debug("Подарок с ID {} недоступен. Причина: " +
                        "isActive={}, isLimited={}, isSoldOut={}, availableQuantity={}",
                        giftId, gift.getIsActive(), gift.getIsLimited(),
                        gift.getIsSoldOut(), gift.getAvailableQuantity());
            } else {
                log.debug("Подарок с ID {} доступен для покупки", giftId);
            }

            return isAvailable;

        } catch (ResponseStatusException e) {
            log.warn("Подарок с ID {} не найден: {}", giftId, e.getMessage());
            return false;
        } catch (Exception e) {
            log.error("Ошибка при проверке доступности подарка {}: {}", giftId, e.getMessage());
            return false;
        }
    }

}