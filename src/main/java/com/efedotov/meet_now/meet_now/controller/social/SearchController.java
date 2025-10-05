package com.efedotov.meet_now.meet_now.controller.social;

import java.util.List;
import java.util.Random;
import java.util.UUID;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
        @PreAuthorize("isAuthenticated()")
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
                        @RequestParam(required = false) String floor) {

                log.info("Запрос к /filtered с параметрами: interests={}, purposes={}, verified={}, ageStart={}, ageStop={}, city={}, floor={}",
                                interests, purposes, verified, ageStart, ageStop, city, floor);

                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
                UUID currentUserId = userDetails.getUserId();

                User sender = userService.getById(currentUserId);
                log.info("Отправитель: {} (ID: {})", sender.getUsername(), sender.getId());

                Specification<User> baseSpec = Specification.allOf(
                                UserSpecifications.notCurrentUser(currentUserId),
                                UserSpecifications.isSearchable(),
                                UserSpecifications.isSearching(),
                                UserSpecifications.isOnline());

                log.info("Базовые условия поиска: isOnline=true, isSearchable=true, isSearching=true, notCurrentUser=true");

                if (interests != null && !interests.isEmpty()) {
                        baseSpec = baseSpec.and(UserSpecifications.hasInterests(interests));
                        log.info("Добавлен фильтр по интересам: {}", interests);
                }

                if (purposes != null && !purposes.isEmpty()) {
                        baseSpec = baseSpec.and(UserSpecifications.hasPurposes(purposes));
                        log.info("Добавлен фильтр по целям: {}", purposes);
                }

                if (verified != null) {
                        baseSpec = baseSpec.and(UserSpecifications.isVerified(verified));
                        log.info("Добавлен фильтр верификации: {}", verified);
                }

                if (ageStart != null || ageStop != null) {
                        baseSpec = baseSpec.and(UserSpecifications.hasAgeRange(ageStart, ageStop));
                        log.info("Добавлен фильтр по возрасту: {} - {}", ageStart, ageStop);
                }

                if (city != null && !city.isEmpty()) {
                        baseSpec = baseSpec.and(UserSpecifications.hasCity(city));
                        log.info("Добавлен фильтр по городу: {}", city);
                }

                if (floor != null && !floor.isEmpty()) {
                        baseSpec = baseSpec.and(UserSpecifications.hasFloor(floor));
                        log.info("Добавлен фильтр по полу: {}", floor);
                }

                List<User> users = userRepository.findAll(baseSpec);

                log.info("Найдено пользователей: {}", users.size());
                for (User user : users) {
                        log.info("Найден пользователь: {} (ID: {}), online: {}, searchable: {}, searching: {}, verified: {}, age: {}, city: {}, floor: {}",
                                        user.getUsername(), user.getId(), user.getIsOnline(),
                                        user.getIsSearchable(), user.getIsSearching(), user.getVerified(),
                                        user.getAge(), user.getCity(), user.getFloor());
                }

                if (users.isEmpty()) {
                        log.warn("Пользователи по фильтрам не найдены");

                        long totalUsers = userRepository.count();
                        long onlineUsers = userRepository.countByIsOnlineTrue();
                        long searchableUsers = userRepository.countByIsSearchableTrue();
                        long searchingUsers = userRepository.countByIsSearchingTrue();

                        log.info("Статистика системы: Всего пользователей: {}, Онлайн: {}, Доступны для поиска: {}, В поиске: {}",
                                        totalUsers, onlineUsers, searchableUsers, searchingUsers);

                        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователи не найдены");
                }

                User recipient = users.get(new Random().nextInt(users.size()));
                log.info("Выбран получатель: {} (ID: {})", recipient.getUsername(), recipient.getId());

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

                log.info("Отправлены уведомления о новом временном чате пользователям {} и {}",
                                sender.getUsername(), recipient.getUsername());

                return dto;
        }
}