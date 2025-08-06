package com.efedotov.meet_now.meet_now.controller.games;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.AddGameRequest;
import com.efedotov.meet_now.meet_now.dto.request.GameCompletionRequest;
import com.efedotov.meet_now.meet_now.dto.request.UpdateGameStateRequest;
import com.efedotov.meet_now.meet_now.model.ChatGame;
import com.efedotov.meet_now.meet_now.service.chat.GamesService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/games")
@RequiredArgsConstructor
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

    @Operation(summary = "Добавить игру в чат")
    @PostMapping
    public ResponseEntity<ChatGame> addGameToChat(@RequestBody AddGameRequest request) {
        ChatGame game = gamesService.createGame(
                request.getChatId(),
                request.getGameType(),
                request.getInitialState());
        return ResponseEntity.ok(game);
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
            @RequestBody GameCompletionRequest request
    ) {
        gamesService.completeGameAndRewardUser(request);
        return ResponseEntity.ok().build();
    }


}