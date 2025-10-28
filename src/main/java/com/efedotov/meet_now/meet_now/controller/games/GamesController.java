package com.efedotov.meet_now.meet_now.controller.games;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
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
import com.efedotov.meet_now.meet_now.dto.request.game.GameCompletionInternalRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.GameCompletionRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.GameConfigRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.UpdateGameStateRequest;
import com.efedotov.meet_now.meet_now.dto.response.game.GameInfoResponse;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;
import com.efedotov.meet_now.meet_now.model.game.GameConfigEntity;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.game.GamesService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/games")
@RequiredArgsConstructor
@EnableMethodSecurity
public class GamesController {
    private final GamesService gamesService;

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

    @Operation(summary = "Получить все конфигурации игр")
    @GetMapping("/configs")
    public ResponseEntity<List<GameConfigEntity>> getAllGameConfigs() {
        List<GameConfigEntity> configs = gamesService.getAllGameConfigs();
        return ResponseEntity.ok(configs);
    }

    @Operation(summary = "Получить конфигурацию игры по типу")
    @GetMapping("/configs/{gameType}")
    public ResponseEntity<GameConfigEntity> getGameConfig(@PathVariable String gameType) {
        GameConfigEntity config = gamesService.getGameConfig(gameType);
        return ResponseEntity.ok(config);
    }

    @Operation(summary = "Создать новую конфигурацию игры")
    @PostMapping("/configs")
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

    @Operation(summary = "Обновить конфигурацию игры")
    @PutMapping("/configs/{gameType}")
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

    @Operation(summary = "Удалить конфигурацию игры")
    @DeleteMapping("/configs/{gameType}")
    public ResponseEntity<Void> deleteGameConfig(@PathVariable String gameType) {
        gamesService.deleteGameConfig(gameType);
        return ResponseEntity.ok().build();
    }

}