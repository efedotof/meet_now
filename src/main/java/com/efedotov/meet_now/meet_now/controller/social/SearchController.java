package com.efedotov.meet_now.meet_now.controller.social;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.request.search.SearchFilters;
import com.efedotov.meet_now.meet_now.dto.request.search.SearchStatus;
import com.efedotov.meet_now.meet_now.dto.response.search.QueueStatsDto;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.social.SearchQueueService;
import com.efedotov.meet_now.meet_now.service.social.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/v1/search")
@Tag(name = "Search", description = "Асинхронный поиск собеседников")
@RequiredArgsConstructor
public class SearchController {

        private final SearchQueueService searchQueueService;
        private final UserService userService;

        @PostMapping("/start")
        @Operation(summary = "Начать поиск собеседника", description = "Добавляет пользователя в очередь поиска с фильтрами")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Поиск начат"),
                        @ApiResponse(responseCode = "400", description = "Пользователь не доступен для поиска")
        })
        public SearchStatus startSearch(
                        @RequestBody(required = false) SearchFilters filters,
                        Authentication authentication) {

                UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();

                try {
                        if (filters == null) {
                                filters = SearchFilters.builder().build();
                        }

                        searchQueueService.addToSearch(userId, filters);
                        return searchQueueService.getSearchStatus(userId);

                } catch (Exception e) {
                        log.error("Failed to start search for user {}", userId, e);
                        throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                                        "Failed to start search: " + e.getMessage());
                }
        }

        @PostMapping("/stop")
        @Operation(summary = "Остановить поиск", description = "Удаляет пользователя из очереди поиска")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Поиск остановлен")
        })
        public SearchStatus stopSearch(Authentication authentication) {
                UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();

                try {
                        searchQueueService.removeFromSearch(userId);
                        userService.stopSearch(userId);
                        return searchQueueService.getSearchStatus(userId);
                } catch (Exception e) {
                        log.error("Failed to stop search for user {}", userId, e);
                        return searchQueueService.getSearchStatus(userId);
                }
        }

        @GetMapping("/status")
        @Operation(summary = "Получить статус поиска", description = "Возвращает текущий статус поиска пользователя")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Статус получен")
        })
        public SearchStatus getSearchStatus(Authentication authentication) {
                UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
                return searchQueueService.getSearchStatus(userId);
        }

        @GetMapping("/queue-info")
        @Operation(summary = "Информация об очередях", description = "Возвращает информацию о текущих очередях поиска")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Информация получена")
        })
        public QueueStatsDto getQueueInfo() {
                return searchQueueService.getQueueStats();
        }
}