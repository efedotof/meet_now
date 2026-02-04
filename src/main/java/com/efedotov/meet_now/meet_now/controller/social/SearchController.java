package com.efedotov.meet_now.meet_now.controller.social;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.request.search.SearchFilters;
import com.efedotov.meet_now.meet_now.dto.request.search.SearchStatus;
import com.efedotov.meet_now.meet_now.dto.response.search.QueueStatsDto;
import com.efedotov.meet_now.meet_now.dto.response.search.SearchResponseDto;
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
        @Operation(summary = "Начать поиск собеседника", description = "Добавляет пользователя в очередь поиска с фильтрами. Возвращает статус и найденный чат если есть совпадение")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Поиск начат или найден собеседник"),
                        @ApiResponse(responseCode = "400", description = "Пользователь не доступен для поиска")
        })
        public ResponseEntity<SearchResponseDto> startSearch(
                        @RequestBody(required = false) SearchFilters filters,
                        Authentication authentication) {

                UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();

                try {
                        if (filters == null) {
                                filters = SearchFilters.builder().build();
                        }

                        var searchResult = searchQueueService.startSearch(userId, filters);

                        SearchResponseDto response;

                        if (searchResult.getMatchedChat() != null) {
                                response = SearchResponseDto.builder()
                                                .message("Собеседник найден!")
                                                .temporaryChat(searchResult.getMatchedChat())
                                                .success(true)
                                                .status("MATCHED")
                                                .queuePosition(null)
                                                .totalInQueue(null)
                                                .build();
                        } else {
                                response = SearchResponseDto.builder()
                                                .message("Поиск начат. Вы в очереди: позиция " +
                                                                searchResult.getQueuePosition() + " из " +
                                                                searchResult.getTotalInQueue())
                                                .temporaryChat(null)
                                                .success(true)
                                                .status("SEARCHING")
                                                .queuePosition(searchResult.getQueuePosition())
                                                .totalInQueue(searchResult.getTotalInQueue())
                                                .build();
                        }

                        return ResponseEntity.ok(response);

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
        public SearchResponseDto stopSearch(Authentication authentication) {
                UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();

                try {
                        searchQueueService.removeFromSearch(userId);
                        userService.stopSearch(userId);

                        return SearchResponseDto.builder()
                                        .message("Поиск остановлен")
                                        .temporaryChat(null)
                                        .success(true)
                                        .status("STOPPED")
                                        .queuePosition(null)
                                        .totalInQueue(null)
                                        .build();
                } catch (Exception e) {
                        log.error("Failed to stop search for user {}", userId, e);
                        return SearchResponseDto.builder()
                                        .message("Ошибка при остановке поиска: " + e.getMessage())
                                        .temporaryChat(null)
                                        .success(false)
                                        .status("STOPPED")
                                        .queuePosition(null)
                                        .totalInQueue(null)
                                        .build();
                }
        }

        @GetMapping("/status")
        @Operation(summary = "Получить статус поиска", description = "Возвращает текущий статус поиска пользователя и найденный чат если есть")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Статус получен")
        })
        public SearchResponseDto getSearchStatus(Authentication authentication) {
                UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
                SearchStatus status = searchQueueService.getSearchStatus(userId);

                SearchResponseDto response = SearchResponseDto.builder()
                                .message(getStatusMessage(status))
                                .temporaryChat(status.getMatchedChat())
                                .success(true)
                                .status(status.getMatchStatus())
                                .queuePosition(status.getQueuePosition())
                                .totalInQueue(status.getTotalInQueue())
                                .build();

                return response;
        }

        @GetMapping("/queue-info")
        @Operation(summary = "Информация об очередях", description = "Возвращает информацию о текущих очередях поиска")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Информация получена")
        })
        public QueueStatsDto getQueueInfo() {
                return searchQueueService.getQueueStats();
        }

        private String getStatusMessage(SearchStatus status) {
                if (status.getMatchedChat() != null) {
                        return "Собеседник найден!";
                } else if (status.isSearching()) {
                        return "Ищем собеседника... Позиция в очереди: " +
                                        status.getQueuePosition() + " из " + status.getTotalInQueue();
                } else {
                        return "Поиск не активен";
                }
        }
}