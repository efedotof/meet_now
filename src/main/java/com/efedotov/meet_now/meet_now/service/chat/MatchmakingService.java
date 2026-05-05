package com.efedotov.meet_now.meet_now.service.chat;

import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.MatchmakingResponse;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.user.FreeSearchUsage;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.FreeSearchUsageRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.service.notification.InternalNotificationService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

import org.springframework.messaging.MessagingException;

@Slf4j
@Service
@RequiredArgsConstructor
public class MatchmakingService {

    private final UserRepository userRepository;
    private final FreeSearchUsageRepository freeSearchUsageRepository;
    private final ChatService chatService;
    private final InternalNotificationService internalNotificationService;
    private final SimpMessagingTemplate messagingTemplate;

    private static final int PREMIUM_SEARCH_COST = 1000;

    @Transactional
    public MatchmakingResponse quickSearch(UUID userId) {
        try {
            User currentUser = userRepository.findById(userId)
                    .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));

            if (Boolean.TRUE.equals(currentUser.getIsSearching())) {
                return MatchmakingResponse.builder()
                        .success(false)
                        .message("Вы уже находитесь в поиске")
                        .build();
            }

            String myFloor = currentUser.getFloor();
            if (myFloor == null || myFloor.isBlank()) {
                return MatchmakingResponse.builder()
                        .success(false)
                        .message("У вас не указан пол")
                        .build();
            }

            String targetFloor;
            if ("male".equalsIgnoreCase(myFloor)) {
                targetFloor = "female";
            } else if ("female".equalsIgnoreCase(myFloor)) {
                targetFloor = "male";
            } else {
                return MatchmakingResponse.builder()
                        .success(false)
                        .message("Некорректное значение пола")
                        .build();
            }

            boolean isPremium = currentUser.getRoles().stream()
                    .anyMatch(role -> "PREMIUM".equals(role.getRoleName()));

            if (isPremium) {
                if (currentUser.getGamePoints() < PREMIUM_SEARCH_COST) {
                    return MatchmakingResponse.builder()
                            .success(false)
                            .message("Недостаточно очков. Требуется: " + PREMIUM_SEARCH_COST)
                            .build();
                }
            } else {
                Optional<FreeSearchUsage> usage = freeSearchUsageRepository.findByUserIdAndUsedDate(userId,
                        LocalDate.now());
                if (usage.isPresent()) {
                    return MatchmakingResponse.builder()
                            .success(false)
                            .message("Вы уже использовали бесплатный поиск сегодня. Попробуйте завтра.")
                            .build();
                }
            }

            User partner = userRepository.findRandomForQuickMatch(userId, targetFloor)
                    .orElse(null);
            if (partner == null) {
                return MatchmakingResponse.builder()
                        .success(false)
                        .message("Нет подходящих собеседников")
                        .build();
            }

            if (currentUser.getPublicKey() == null || currentUser.getPublicKey().isBlank()) {
                log.warn("User {} has no public key", userId);
                return MatchmakingResponse.builder()
                        .success(false)
                        .message("Ваш профиль не настроен для шифрования. Пожалуйста, выйдите и войдите снова.")
                        .build();
            }
            if (partner.getPublicKey() == null || partner.getPublicKey().isBlank()) {
                log.warn("Partner {} has no public key", partner.getId());
                return MatchmakingResponse.builder()
                        .success(false)
                        .message("У выбранного собеседника отсутствует публичный ключ. Попробуйте позже.")
                        .build();
            }

            if (isPremium) {
                currentUser.setGamePoints(currentUser.getGamePoints() - PREMIUM_SEARCH_COST);
                userRepository.save(currentUser);
            } else {
                FreeSearchUsage usage = new FreeSearchUsage();
                usage.setUserId(userId);
                usage.setUsedAt(LocalDateTime.now());
                usage.setUsedDate(LocalDate.now());
                freeSearchUsageRepository.save(usage);
            }

            Chat chat;
            try {
                chat = chatService.createOrGetPermanentChat(userId, partner.getId());
            } catch (Exception e) {
                log.error("Ошибка создания постоянного чата при быстром поиске", e);
                return MatchmakingResponse.builder()
                        .success(false)
                        .message("Не удалось создать чат: " + e.getMessage())
                        .build();
            }

            currentUser.setIsSearching(false);
            partner.setIsSearching(false);
            userRepository.saveAll(List.of(currentUser, partner));

            PermanentChatResponseDto permanentChatDto = mapToPermanentChatDto(chat);

            try {
                messagingTemplate.convertAndSendToUser(
                        partner.getUsername(),
                        "/queue/chat.permanent.updated",
                        permanentChatDto);
            } catch (MessagingException e) {
                log.warn("Не удалось отправить WebSocket уведомление пользователю {}", partner.getUsername());
            }

            Map<String, String> data = new HashMap<>();
            data.put("type", "new_match");
            data.put("chatId", chat.getChatId().toString());
            data.put("action", "open_chat");
            internalNotificationService.sendSystemDataNotification(
                    partner.getId(),
                    "У вас новый собеседник!",
                    "Новый чат",
                    data);

            return MatchmakingResponse.builder()
                    .success(true)
                    .message("Собеседник найден!")
                    .permanentChat(permanentChatDto)
                    .chatId(chat.getChatId())
                    .pointsSpent(isPremium ? PREMIUM_SEARCH_COST : 0)
                    .build();

        } catch (Exception e) {
            log.error("Неожиданная ошибка в quickSearch", e);
            return MatchmakingResponse.builder()
                    .success(false)
                    .message("Произошла ошибка: " + e.getMessage())
                    .build();
        }
    }

    private PermanentChatResponseDto mapToPermanentChatDto(Chat chat) {
        PermanentChatResponseDto dto = new PermanentChatResponseDto();
        dto.setChatId(chat.getChatId());
        User user1 = chat.getUser1();
        User user2 = chat.getUser2();
        dto.setUser1Id(user1.getId());
        dto.setUser1Username(user1.getUsername());
        dto.setUser1Firstname(user1.getFirstname());
        dto.setUser1Subname(user1.getSubname());
        dto.setUser1Avatar(user1.getAvatar());
        dto.setUser2Id(user2.getId());
        dto.setUser2Username(user2.getUsername());
        dto.setUser2Firstname(user2.getFirstname());
        dto.setUser2Subname(user2.getSubname());
        dto.setUser2Avatar(user2.getAvatar());
        dto.setCreatedAt(chat.getCreatedAt());
        dto.setIsOpened(chat.getIsOpened());
        dto.setLastMessage(chat.getLastMessage());
        dto.setLastMessageAt(chat.getLastMessageAt());
        return dto;
    }
}