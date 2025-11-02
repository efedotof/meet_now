package com.efedotov.meet_now.meet_now.controller.social;

import java.util.List;
import java.util.Random;
import java.util.UUID;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.MessagingException;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.response.chat.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;
import com.efedotov.meet_now.meet_now.service.social.UserService;
import com.efedotov.meet_now.meet_now.service.util.UserSpecifications;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/search")
@Tag(name = "Search", description = "Поиск доступных для общения пользователей и автоматическое создание временного чата")
@RequiredArgsConstructor
@EnableMethodSecurity
public class SearchController {

    private final UserRepository userRepository;
    private final UserService userService;
    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    @GetMapping("/filtered")
    @Operation(summary = "Поиск пользователя по фильтрам", description = "Поиск по интересам, целям, верификации, возрасту, городу и полу с созданием чата")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Чат создан успешно"),
            @ApiResponse(responseCode = "404", description = "Пользователи не найдены")
    })
    public TemporaryChatDto findUserByFiltersAndCreateChat(
            @RequestParam(required = false) List<String> interests,
            @RequestParam(required = false) List<String> purposes,
            @RequestParam(required = false) Boolean verified,
            @RequestParam(required = false) Integer ageStart,
            @RequestParam(required = false) Integer ageStop,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String floor,
            Authentication authentication) {

        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        User sender = userService.getById(userId);

        log.info("Поиск для пользователя: {} (ID: {})", sender.getUsername(), sender.getId());
        log.info("Параметры поиска: floor={}, age={}-{}, verified={}", floor, ageStart, ageStop, verified);

        if (!userService.isUserAvailableForSearch(userId)) {
            log.warn("Отправитель {} недоступен для поиска. Статусы: online={}, searchable={}, searching={}",
                    sender.getUsername(), sender.getIsOnline(), sender.getIsSearchable(), sender.getIsSearching());
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User is not available for search");
        }

        Specification<User> baseSpec = Specification.allOf(
                UserSpecifications.notCurrentUser(userId),
                UserSpecifications.isOnline(),
                UserSpecifications.isSearchable(),
                UserSpecifications.isSearching());

        log.info("Базовые условия поиска: isOnline=true, isSearchable=true, isSearching=true, notCurrentUser=true");

        if (floor != null && !floor.isEmpty()) {
            baseSpec = baseSpec.and(UserSpecifications.hasFloor(floor));
            log.info("Добавлен фильтр по полу: {}", floor);
        }

        if (ageStart != null || ageStop != null) {
            baseSpec = baseSpec.and(UserSpecifications.hasAgeRange(ageStart, ageStop));
            log.info("Добавлен фильтр по возрасту: {} - {}", ageStart, ageStop);
        }

        if (verified != null) {
            baseSpec = baseSpec.and(UserSpecifications.isVerified(verified));
            log.info("Добавлен фильтр верификации: {}", verified);
        }

        if (interests != null && !interests.isEmpty()) {
            baseSpec = baseSpec.and(UserSpecifications.hasInterests(interests));
            log.info("Добавлен фильтр по интересам: {}", interests);
        }

        if (purposes != null && !purposes.isEmpty()) {
            baseSpec = baseSpec.and(UserSpecifications.hasPurposes(purposes));
            log.info("Добавлен фильтр по целям: {}", purposes);
        }

        if (city != null && !city.isEmpty()) {
            baseSpec = baseSpec.and(UserSpecifications.hasCity(city));
            log.info("Добавлен фильтр по городу: {}", city);
        }

        long onlineUsers = userRepository.countByIsOnlineTrue();
        long searchableUsers = userRepository.countByIsSearchableTrue();
        long searchingUsers = userRepository.countByIsSearchingTrue();

        log.info("Статистика системы: Онлайн: {}, Доступны для поиска: {}, В активном поиске: {}",
                onlineUsers, searchableUsers, searchingUsers);

        List<User> users = userRepository.findAll(baseSpec);
        log.info("Найдено подходящих пользователей: {}", users.size());

        for (User user : users) {
            log.info(
                    "Найден пользователь: {} ({}), возраст: {}, пол: {}, verified: {}, online: {}, searchable: {}, searching: {}",
                    user.getUsername(), user.getId(), user.getAge(), user.getFloor(),
                    user.getVerified(), user.getIsOnline(), user.getIsSearchable(), user.getIsSearching());
        }

        if (users.isEmpty()) {
            log.warn("Пользователи по фильтрам не найдены для пользователя {}", sender.getUsername());

            List<User> allSearchingUsers = userRepository.findByIsSearchingTrue();
            log.info("Все пользователи в поиске ({}):", allSearchingUsers.size());
            for (User user : allSearchingUsers) {
                if (!user.getId().equals(userId)) {
                    log.info(" - {} ({}), возраст: {}, пол: {}, online: {}, searchable: {}",
                            user.getUsername(), user.getId(), user.getAge(), user.getFloor(),
                            user.getIsOnline(), user.getIsSearchable());
                }
            }

            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователи не найдены");
        }

        User recipient = users.get(new Random().nextInt(users.size()));
        log.info("Выбран получатель: {} (ID: {})", recipient.getUsername(), recipient.getId());

        try {

            var tempChat = chatService.createTemporaryChat(sender, recipient, 5);

            TemporaryChatDto dto = TemporaryChatDto.builder()
                    .tempChatId(tempChat.getTempChatId())
                    .senderId(tempChat.getSender().getId())
                    .recipientId(tempChat.getRecipient().getId())
                    .createdAt(tempChat.getCreatedAt())
                    .durationMinutes(tempChat.getDurationMinutes())
                    .isFinished(tempChat.getIsFinished())
                    .bothAgreed(tempChat.getBothAgreed())
                    .build();

            messagingTemplate.convertAndSendToUser(
                    sender.getUsername(),
                    "/queue/chat.temporary.new",
                    dto);
            messagingTemplate.convertAndSendToUser(
                    recipient.getUsername(),
                    "/queue/chat.temporary.new",
                    dto);

            log.info("Успешно создан временный чат между {} и {}",
                    sender.getUsername(), recipient.getUsername());

            return dto;

        } catch (MessagingException e) {
            log.error("Ошибка при создании чата между {} и {}",
                    sender.getUsername(), recipient.getUsername(), e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Ошибка при создании чата");
        }
    }
}