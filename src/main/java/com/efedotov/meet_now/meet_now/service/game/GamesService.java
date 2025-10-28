package com.efedotov.meet_now.meet_now.service.game;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.request.game.GameCompletionInternalRequest;
import com.efedotov.meet_now.meet_now.dto.response.game.GameInfoResponse;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;
import com.efedotov.meet_now.meet_now.model.game.GameConfigEntity;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.game.GameConfigRepository;
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
    private final GameConfigRepository gameConfigRepository;
    private final UserRepository userRepository;

    public String getGameUrl(String gameType) {
        return gameConfigRepository.findByGameType(gameType)
                .map(GameConfigEntity::getGameUrl)
                .orElse("");
    }

    public List<ChatGame> getGamesByChatId(UUID chatId) {
        return repository.findByChatId(chatId);
    }

    public List<ChatGame> getAllGames() {
        return repository.findAll();
    }

    @Transactional
    public ChatGame createGame(UUID chatId, String gameType, String initialState) {
        if (!gameConfigRepository.existsByGameType(gameType)) {
            throw new IllegalArgumentException("Game type not found: " + gameType);
        }

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

    @Transactional
    public void completeGameAndRewardUser(GameCompletionInternalRequest request) {
        GameConfigEntity gameConfig = gameConfigRepository.findByGameType(request.getGameType())
                .orElseThrow(() -> new IllegalArgumentException("Game type not found: " + request.getGameType()));

        double multiplier = gameConfig.getScoreMultiplier().doubleValue();
        int points = (int) (request.getScore() * multiplier);

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        user.setGamePoints(user.getGamePoints() + points);
        userRepository.save(user);

        if (request.getChatId() != null) {
            log.info("Начислено {} очков пользователю {} за игру {} в чате {}",
                    points, user.getUsername(), request.getGameType(), request.getChatId());
        } else {
            log.info("Начислено {} очков пользователю {} за игру {} (без привязки к чату)",
                    points, user.getUsername(), request.getGameType());
        }
    }

    public Map<String, String> getAllGameUrls() {
        return gameConfigRepository.findByIsActiveTrue().stream()
                .collect(Collectors.toMap(
                        GameConfigEntity::getGameType,
                        GameConfigEntity::getGameUrl));
    }

    public List<GameInfoResponse> getAllGameInfo() {
        List<GameConfigEntity> allGames = gameConfigRepository.findAll();
        log.info("Found {} total games in database", allGames.size());

        return allGames.stream()
                .map(this::convertToGameInfoResponse)
                .collect(Collectors.toList());
    }

    private GameInfoResponse convertToGameInfoResponse(GameConfigEntity gameConfig) {
        return new GameInfoResponse(
                gameConfig.getGameType(),
                gameConfig.getGameUrl(),
                gameConfig.getGameName(),
                gameConfig.getGameDescription(),
                gameConfig.getThumbnailUrl());
    }

    public List<GameConfigEntity> getAllGameConfigs() {
        return gameConfigRepository.findAll();
    }

    public GameConfigEntity getGameConfig(String gameType) {
        return gameConfigRepository.findByGameType(gameType)
                .orElseThrow(() -> new IllegalArgumentException("Game config not found: " + gameType));
    }

    public GameConfigEntity createGameConfig(GameConfigEntity gameConfig) {
        if (gameConfigRepository.existsByGameType(gameConfig.getGameType())) {
            throw new IllegalArgumentException("Game type already exists: " + gameConfig.getGameType());
        }
        return gameConfigRepository.save(gameConfig);
    }

    public GameConfigEntity updateGameConfig(String gameType, GameConfigEntity gameConfig) {
        GameConfigEntity existing = getGameConfig(gameType);
        gameConfig.setId(existing.getId());
        return gameConfigRepository.save(gameConfig);
    }

    public void deleteGameConfig(String gameType) {
        GameConfigEntity gameConfig = getGameConfig(gameType);
        gameConfigRepository.delete(gameConfig);
    }
}