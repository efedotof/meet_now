package com.efedotov.meet_now.meet_now.service.game;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import jakarta.persistence.criteria.Predicate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.request.game.BulkGameUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.request.game.GameCompletionInternalRequest;
import com.efedotov.meet_now.meet_now.dto.response.game.CleanupResultResponse;
import com.efedotov.meet_now.meet_now.dto.response.game.GameExportResponse;
import com.efedotov.meet_now.meet_now.dto.response.game.GameInfoResponse;
import com.efedotov.meet_now.meet_now.dto.response.game.GameStatisticsResponse;
import com.efedotov.meet_now.meet_now.dto.response.game.GameTypeStatisticDto;
import com.efedotov.meet_now.meet_now.dto.response.game.GameTypeStatsDTO;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;
import com.efedotov.meet_now.meet_now.model.game.GameConfigEntity;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatGameRepository;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.game.GameConfigRepository;
import com.efedotov.meet_now.meet_now.repository.game.GamesRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

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
    private final ChatGameRepository chatGameRepository;

    @AdminOnly
    public GameStatisticsResponse getGameStatistics() {
        long totalGames = repository.count();
        long totalChatGames = repository.countByChatIsNotNull();
        long totalStandaloneGames = repository.countByChatIsNull();

        List<GameTypeStatsDTO> popularGames = repository.findMostPopularGameTypes();

        return GameStatisticsResponse.builder()
                .totalGames(totalGames)
                .totalChatGames(totalChatGames)
                .totalStandaloneGames(totalStandaloneGames)
                .gamesByType(getGamesByType())
                .popularGames(popularGames)
                .generatedAt(LocalDateTime.now())
                .build();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private List<GameTypeStatisticDto> getGamesByType() {
        Map<String, Long> gamesByTypeMap = new HashMap<>();

        chatGameRepository.findAll().forEach(game -> {
            String gameType = game.getGameType();
            gamesByTypeMap.put(gameType, gamesByTypeMap.getOrDefault(gameType, 0L) + 1);
        });

        return gamesByTypeMap.entrySet().stream()
                .map(entry -> GameTypeStatisticDto.builder()
                        .gameType(entry.getKey())
                        .count(entry.getValue())
                        .build())
                .collect(Collectors.toList());
    }

    @AdminOnly
    public Page<ChatGame> getAllGamesWithPagination(int page, int size, String gameType) {
        Pageable pageable = PageRequest.of(page, size);

        if (gameType != null && !gameType.isEmpty()) {
            return repository.findByGameType(gameType, pageable);
        }

        return repository.findAll(pageable);
    }

    @AdminOnly
    public Page<ChatGame> searchGames(UUID chatId, String gameType, LocalDateTime startDate,
            LocalDateTime endDate, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);

        Specification<ChatGame> spec = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (chatId != null) {
                predicates.add(criteriaBuilder.equal(root.get("chat").get("id"), chatId));
            }

            if (gameType != null && !gameType.isEmpty()) {
                predicates.add(criteriaBuilder.equal(root.get("gameType"), gameType));
            }

            if (startDate != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("createdAt"), startDate));
            }

            if (endDate != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("createdAt"), endDate));
            }

            return criteriaBuilder.and(predicates.toArray(Predicate[]::new));
        };

        return repository.findAll(spec, pageable);
    }

    @AdminOnly
    public ChatGame getGameDetails(UUID gameId) {
        return repository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found: " + gameId));
    }

    @AdminOnly
    @Transactional
    public void bulkDeleteGames(List<UUID> gameIds) {
        if (gameIds == null || gameIds.isEmpty()) {
            throw new IllegalArgumentException("Game IDs list cannot be empty");
        }
        int deletedCount = repository.deleteByIdIn(gameIds);
        log.info("Bulk deleted {} games", deletedCount);
    }

    @AdminOnly
    @Transactional
    public CleanupResultResponse cleanupOldGames(int daysOld) {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(daysOld);

        int deletedCount = repository.deleteByCreatedAtBefore(cutoffDate);

        return CleanupResultResponse.builder()
                .deletedGamesCount((long) deletedCount)
                .cutoffDate(cutoffDate)
                .message("Successfully deleted " + deletedCount + " games older than " + daysOld + " days")
                .build();
    }

    @AdminOnly
    public GameExportResponse exportGamesData(LocalDateTime startDate, LocalDateTime endDate) {
        List<ChatGame> games;

        if (startDate != null && endDate != null) {
            games = repository.findByCreatedAtBetween(startDate, endDate);
        } else if (startDate != null) {
            games = repository.findByCreatedAtAfter(startDate);
        } else if (endDate != null) {
            games = repository.findByCreatedAtBefore(endDate);
        } else {
            games = repository.findAll();
        }

        long totalGames = games.size();
        long gamesWithChat = games.stream().filter(game -> game.getChat() != null).count();

        return GameExportResponse.builder()
                .games(games)
                .totalGames(totalGames)
                .gamesWithChat(gamesWithChat)
                .gamesWithoutChat(totalGames - gamesWithChat)
                .gamesByType(getGamesByType())
                .exportTimestamp(LocalDateTime.now())
                .build();
    }

    @AdminOnly
    @Transactional
    public List<ChatGame> bulkUpdateGames(List<BulkGameUpdateRequest> requests) {
        List<ChatGame> updatedGames = new ArrayList<>();

        for (BulkGameUpdateRequest request : requests) {
            ChatGame game = repository.findById(request.getGameId())
                    .orElseThrow(() -> new IllegalArgumentException("Game not found: " + request.getGameId()));

            if (request.getNewState() != null) {
                game.setState(request.getNewState());
            }

            if (request.getGameType() != null) {
                game.setGameType(request.getGameType());
            }

            updatedGames.add(repository.save(game));
        }

        return updatedGames;
    }

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

    @AdminOnly
    public List<GameConfigEntity> getAllGameConfigs() {
        return gameConfigRepository.findAll();
    }

    @AdminOnly
    public GameConfigEntity getGameConfig(String gameType) {
        return gameConfigRepository.findByGameType(gameType)
                .orElseThrow(() -> new IllegalArgumentException("Game config not found: " + gameType));
    }

    @AdminOnly
    public GameConfigEntity createGameConfig(GameConfigEntity gameConfig) {
        if (gameConfigRepository.existsByGameType(gameConfig.getGameType())) {
            throw new IllegalArgumentException("Game type already exists: " + gameConfig.getGameType());
        }
        return gameConfigRepository.save(gameConfig);
    }

    @AdminOnly
    public GameConfigEntity updateGameConfig(String gameType, GameConfigEntity gameConfig) {
        GameConfigEntity existing = getGameConfig(gameType);
        gameConfig.setId(existing.getId());
        return gameConfigRepository.save(gameConfig);
    }

    @AdminOnly
    public void deleteGameConfig(String gameType) {
        GameConfigEntity gameConfig = getGameConfig(gameType);
        gameConfigRepository.delete(gameConfig);
    }
}