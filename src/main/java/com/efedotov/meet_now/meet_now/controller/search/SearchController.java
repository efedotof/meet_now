package com.efedotov.meet_now.meet_now.controller.search;

import java.util.List;
import java.util.Objects;
import java.util.Random;
import java.util.UUID;
import java.util.stream.Stream;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.UserRepository;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;
import com.efedotov.meet_now.meet_now.service.user.UserService;
import com.efedotov.meet_now.meet_now.service.user.UserSpecifications;

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
public class SearchController {

    private final UserRepository userRepository;
    private final UserService userService;
    private final ChatService chatService;

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

        Specification<User> spec = Stream.of(
                UserSpecifications.notCurrentUser(currentUserId),
                UserSpecifications.isSearchable(),
                UserSpecifications.isOnline(),
                UserSpecifications.hasInterests(interests),
                UserSpecifications.hasPurposes(purposes),
                (verified != null && verified) ? UserSpecifications.isVerified(true) : null,
                UserSpecifications.hasAgeRange(ageStart, ageStop), 
                UserSpecifications.hasCity(city),
                UserSpecifications.hasFloor(floor)
        )
        .filter(Objects::nonNull)
        .reduce(Specification::and)
        .orElse(null);

        List<User> users = (spec != null) 
                ? userRepository.findAll(spec) 
                : userRepository.findByIsSearchableTrueAndIsOnlineTrue();

        users = users.stream()
                .filter(user -> !user.getId().equals(currentUserId))
                .filter(User::getIsOnline)
                .toList();

        log.info("Найдено пользователей: {}", users.size());
        
        if (users.isEmpty()) {
            log.warn("Пользователи по фильтрам не найдены");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Пользователи не найдены");
        }

        User recipient = users.get(new Random().nextInt(users.size()));
        var tempChat = chatService.createTemporaryChat(sender, recipient, 5);

        return TemporaryChatDto.builder()
                .tempChatId(tempChat.getTempChatId())
                .senderId(tempChat.getSender().getId())
                .recipientId(tempChat.getRecipient().getId())
                .createdAt(tempChat.getCreatedAt())
                .durationMinutes(tempChat.getDurationMinutes())
                .isFinished(tempChat.getIsFinished())
                .bothAgreed(tempChat.getBothAgreed())
                .build();
    }
}