package com.efedotov.meet_now.meet_now.controller.search;

import com.efedotov.meet_now.meet_now.dto.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.service.ChatService;
import com.efedotov.meet_now.meet_now.service.UserService;
import com.efedotov.meet_now.meet_now.repository.UserRepository;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/search")
@Tag(
    name = "Search", 
    description = "Поиск доступных для общения пользователей и автоматическое создание временного чата"
)
@RequiredArgsConstructor
public class SearchController {

    private final UserRepository userRepository;
    private final UserService userService;
    private final ChatService chatService;

    @GetMapping("/random")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Поиск случайного пользователя", description = "Ищет пользователя с разрешённой публичностью профиля и создает временный чат")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Пользователь найден и временный чат создан"),
        @ApiResponse(responseCode = "404", description = "Подходящий пользователь не найден")
    })
    public TemporaryChatDto findRandomUserAndCreateChat(@RequestParam UUID requesterId) {
        User sender = userService.getById(requesterId);

        // Поиск случайного пользователя, кроме самого себя, с isSearchable = true
        User recipient = userRepository.findAll().stream()
                .filter(user -> !user.getId().equals(sender.getId()))
                .filter(User::getIsSearchable)
                .findAny()
                .orElseThrow(() -> new RuntimeException("Нет доступных пользователей для общения"));

        // Создание временного чата
        var tempChat = chatService.createTemporaryChat(sender, recipient, 5);

        // Формирование DTO
        TemporaryChatDto dto = new TemporaryChatDto();
        dto.setTempChatId(tempChat.getTempChatId());
        dto.setSenderId(tempChat.getSender().getId());
        dto.setRecipientId(tempChat.getRecipient().getId());
        dto.setCreatedAt(tempChat.getCreatedAt());
        dto.setDurationMinutes(tempChat.getDurationMinutes());
        dto.setIsFinished(tempChat.getIsFinished());
        dto.setBothAgreed(tempChat.getBothAgreed());

        return dto;
    }
}
