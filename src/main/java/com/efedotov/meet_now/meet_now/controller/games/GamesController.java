package com.efedotov.meet_now.meet_now.controller.games;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.game.AddGameRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.BulkGameUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.GameCompletionInternalRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.GameCompletionRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.GameConfigRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.UpdateGameStateRequest;
import com.efedotov.meet_now.meet_now.dto.response.game.CleanupResultResponse;
import com.efedotov.meet_now.meet_now.dto.response.game.GameExportResponse;
import com.efedotov.meet_now.meet_now.dto.response.game.GameInfoResponse;
import com.efedotov.meet_now.meet_now.dto.response.game.GameStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;
import com.efedotov.meet_now.meet_now.model.game.GameConfigEntity;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.game.GamesService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/games")
@RequiredArgsConstructor
public class GamesController {
    private final GamesService gamesService;

    @Operation(summary = "Получить статистику по играм (только для администратора)")
    @GetMapping("/admin/statistics")
    @AdminOnly
    public ResponseEntity<GameStatisticsResponse> getGameStatistics() {
        GameStatisticsResponse statistics = gamesService.getGameStatistics();
        return ResponseEntity.ok(statistics);
    }

    @Operation(summary = "Получить все конфигурации игр с пагинацией (только для администратора)")
    @GetMapping("/admin/all")
    @AdminOnly
    public ResponseEntity<Page<GameConfigEntity>> getAllGameConfigsWithPagination(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String gameType) {
        Page<GameConfigEntity> configs = gamesService.getAllGameConfigsWithPagination(page, size, gameType);
        return ResponseEntity.ok(configs);
    }

    @Operation(summary = "Поиск конфигураций игр по параметрам (только для администратора)")
    @GetMapping("/admin/search")
    @AdminOnly
    public ResponseEntity<Page<GameConfigEntity>> searchGameConfigs(
            @RequestParam(required = false) String gameType,
            @RequestParam(required = false) String gameName,
            @RequestParam(required = false) Boolean isActive,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        Page<GameConfigEntity> configs = gamesService.searchGameConfigs(gameType, gameName, isActive, page, size);
        return ResponseEntity.ok(configs);
    }

    @Operation(summary = "Получить детальную информацию об игре (только для администратора)")
    @GetMapping("/admin/{gameId}")
    @AdminOnly
    public ResponseEntity<ChatGame> getGameDetails(@PathVariable UUID gameId) {
        ChatGame game = gamesService.getGameDetails(gameId);
        return ResponseEntity.ok(game);
    }

    @Operation(summary = "Массовое удаление игр (только для администратора)")
    @DeleteMapping("/admin/bulk")
    @AdminOnly
    public ResponseEntity<Void> bulkDeleteGames(@RequestBody List<UUID> gameIds) {
        gamesService.bulkDeleteGames(gameIds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Очистить старые игры (только для администратора)")
    @DeleteMapping("/admin/cleanup")
    @AdminOnly
    public ResponseEntity<CleanupResultResponse> cleanupOldGames(
            @RequestParam(defaultValue = "30") int daysOld) {
        CleanupResultResponse result = gamesService.cleanupOldGames(daysOld);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "Экспорт данных об играх (только для администратора)")
    @GetMapping("/admin/export")
    @AdminOnly
    public ResponseEntity<GameExportResponse> exportGamesData(
            @RequestParam(required = false) LocalDateTime startDate,
            @RequestParam(required = false) LocalDateTime endDate) {
        GameExportResponse exportData = gamesService.exportGamesData(startDate, endDate);
        return ResponseEntity.ok(exportData);
    }

    @Operation(summary = "Обновить несколько игр (только для администратора)")
    @PutMapping("/admin/bulk")
    @AdminOnly
    public ResponseEntity<List<ChatGame>> bulkUpdateGames(
            @RequestBody List<BulkGameUpdateRequest> requests) {
        List<ChatGame> updatedGames = gamesService.bulkUpdateGames(requests);
        return ResponseEntity.ok(updatedGames);
    }

    @Operation(summary = "Получить URL игры по типу")
    @GetMapping("/url/{gameType}")
    public ResponseEntity<String> getGameUrl(@PathVariable String gameType) {
        String url = gamesService.getGameUrl(gameType);
        return ResponseEntity.ok(url);
    }

    @Operation(summary = "Получить игры чата")
    @GetMapping("/chat/{chatId}")
    public ResponseEntity<List<ChatGame>> getChatGames(@PathVariable UUID chatId) {
        List<ChatGame> games = gamesService.getGamesByChatId(chatId);
        return ResponseEntity.ok(games);
    }

    @Operation(summary = "Обновить состояние игры")
    @PutMapping("/{gameId}")
    public ResponseEntity<ChatGame> updateGameState(
            @PathVariable UUID gameId,
            @RequestBody UpdateGameStateRequest request) {
        ChatGame updatedGame = gamesService.updateGameState(gameId, request.getNewState());
        return ResponseEntity.ok(updatedGame);
    }

    @Operation(summary = "Удалить игру")
    @DeleteMapping("/{gameId}")
    public ResponseEntity<Void> deleteGame(@PathVariable UUID gameId) {
        gamesService.deleteGame(gameId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Завершить игру и начислить очки")
    @PostMapping("/complete")
    public ResponseEntity<Void> completeGame(
            @RequestBody GameCompletionRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        log.info("Received game completion request: gameType={}, score={}, chatId={}",
                request.getGameType(), request.getScore(), request.getChatId());

        if (userDetails == null) {
            log.error("UserDetails is null - authentication failed");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = userDetails.getUserId();
        log.info("Processing game completion for user: {}", userId);

        GameCompletionInternalRequest internalRequest = new GameCompletionInternalRequest(
                userId,
                request.getChatId(),
                request.getGameType(),
                request.getScore());

        gamesService.completeGameAndRewardUser(internalRequest);

        log.info("Game completion processed successfully for user: {}", userId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить игры по ID чата или все игры")
    @GetMapping
    public ResponseEntity<List<ChatGame>> getGames(
            @RequestParam(required = false) UUID chatId) {
        List<ChatGame> games;
        if (chatId != null) {
            games = gamesService.getGamesByChatId(chatId);
        } else {
            games = gamesService.getAllGames();
        }
        return ResponseEntity.ok(games);
    }

    @Operation(summary = "Добавить игру (с привязкой к чату или без)")
    @PostMapping
    public ResponseEntity<ChatGame> addGame(@RequestBody AddGameRequest request) {
        ChatGame game = gamesService.createGame(
                request.getChatId(),
                request.getGameType(),
                request.getInitialState());
        return ResponseEntity.ok(game);
    }

    @Operation(summary = "Получить все URL игр")
    @GetMapping("/urls")
    public ResponseEntity<Map<String, String>> getAllGameUrls() {
        Map<String, String> urls = gamesService.getAllGameUrls();
        return ResponseEntity.ok(urls);
    }

    @Operation(summary = "Получить список всех игр с типами и ссылками")
    @GetMapping("/list")
    public ResponseEntity<List<GameInfoResponse>> getAllGamesInfo() {
        List<GameInfoResponse> games = gamesService.getAllGameInfo();
        return ResponseEntity.ok(games);
    }

    @Operation(summary = "Получить все конфигурации игр (только для администратора)")
    @GetMapping("/admin/configs")
    @AdminOnly
    public ResponseEntity<List<GameConfigEntity>> getAllGameConfigs() {
        List<GameConfigEntity> configs = gamesService.getAllGameConfigs();
        return ResponseEntity.ok(configs);
    }

    @Operation(summary = "Получить конфигурацию игры по типу (только для администратора)")
    @GetMapping("/admin/configs/{gameType}")
    @AdminOnly
    public ResponseEntity<GameConfigEntity> getGameConfig(@PathVariable String gameType) {
        GameConfigEntity config = gamesService.getGameConfig(gameType);
        return ResponseEntity.ok(config);
    }

    @Operation(summary = "Создать новую конфигурацию игры (только для администратора)")
    @PostMapping("/admin/configs")
    @AdminOnly
    public ResponseEntity<GameConfigEntity> createGameConfig(@RequestBody GameConfigRequest request) {
        GameConfigEntity gameConfig = new GameConfigEntity();
        gameConfig.setGameType(request.getGameType());
        gameConfig.setGameUrl(request.getGameUrl());
        gameConfig.setScoreMultiplier(request.getScoreMultiplier());
        gameConfig.setGameName(request.getGameName());
        gameConfig.setGameDescription(request.getGameDescription());
        gameConfig.setThumbnailUrl(request.getThumbnailUrl());
        gameConfig.setIsActive(request.getIsActive());

        GameConfigEntity savedConfig = gamesService.createGameConfig(gameConfig);
        return ResponseEntity.ok(savedConfig);
    }

    @Operation(summary = "Обновить конфигурацию игры (только для администратора)")
    @PutMapping("/admin/configs/{gameType}")
    @AdminOnly
    public ResponseEntity<GameConfigEntity> updateGameConfig(
            @PathVariable String gameType,
            @RequestBody GameConfigRequest request) {
        GameConfigEntity gameConfig = new GameConfigEntity();
        gameConfig.setGameType(request.getGameType());
        gameConfig.setGameUrl(request.getGameUrl());
        gameConfig.setScoreMultiplier(request.getScoreMultiplier());
        gameConfig.setGameName(request.getGameName());
        gameConfig.setGameDescription(request.getGameDescription());
        gameConfig.setThumbnailUrl(request.getThumbnailUrl());
        gameConfig.setIsActive(request.getIsActive());

        GameConfigEntity updatedConfig = gamesService.updateGameConfig(gameType, gameConfig);
        return ResponseEntity.ok(updatedConfig);
    }

    @Operation(summary = "Удалить конфигурацию игры (только для администратора)")
    @DeleteMapping("/admin/configs/{gameType}")
    @AdminOnly
    public ResponseEntity<Void> deleteGameConfig(@PathVariable String gameType) {
        gamesService.deleteGameConfig(gameType);
        return ResponseEntity.ok().build();
    }
}