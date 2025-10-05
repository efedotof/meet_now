package com.efedotov.meet_now.meet_now.service.game;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.config.GameConfig;
import com.efedotov.meet_now.meet_now.dto.request.game.GameCompletionRequest;
import com.efedotov.meet_now.meet_now.dto.response.game.GameInfoResponse;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.game.GamesRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class GamesService {
    private final GamesRepository repository;
    private final ChatRepository chatRepository;
    private final GameConfig gameConfig;
    private final UserRepository userRepository;

    public String getGameUrl(String gameType) {
        return gameConfig.getUrl(gameType);
    }

    public List<ChatGame> getGamesByChatId(UUID chatId) {
        return repository.findByChatId(chatId);
    }

    public List<ChatGame> getAllGames() {
        return repository.findAll();
    }

    public ChatGame createGame(UUID chatId, String gameType, String initialState) {
        ChatGame game = new ChatGame();
        game.setGameType(gameType);
        game.setState(initialState);

        if (chatId != null) {
            Chat chat = chatRepository.findById(chatId)
                    .orElseThrow(() -> new IllegalArgumentException("Chat not found: " + chatId));
            game.setChat(chat);
        }

        return repository.save(game);
    }

    public ChatGame updateGameState(UUID gameId, String newState) {
        ChatGame game = repository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found: " + gameId));
        game.setState(newState);
        return repository.save(game);
    }

    public void deleteGame(UUID gameId) {
        repository.deleteById(gameId);
    }

    public void completeGameAndRewardUser(GameCompletionRequest request) {
        int points = gameConfig.convertScoreToPoints(request.getGameType(), request.getScore());

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        user.setGamePoints(user.getGamePoints() + points);
        userRepository.save(user);

        log.info("Начислено {} очков пользователю {}", points, user.getUsername());
    }

    public Map<String, String> getAllGameUrls() {
        return gameConfig.getAllUrls();
    }

    public List<GameInfoResponse> getAllGameInfo() {
        return gameConfig.getAllUrls().entrySet().stream()
                .map(entry -> new GameInfoResponse(entry.getKey(), entry.getValue()))
                .collect(Collectors.toList());
    }

}