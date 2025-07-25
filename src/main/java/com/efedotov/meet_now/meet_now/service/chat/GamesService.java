package com.efedotov.meet_now.meet_now.service.chat;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.config.GameConfig;
import com.efedotov.meet_now.meet_now.model.Chat;
import com.efedotov.meet_now.meet_now.model.ChatGame;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.GamesRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class GamesService {
    private final GamesRepository repository;
    private final ChatRepository chatRepository;
    private final GameConfig gameConfig;

    public String getGameUrl(String gameType) {
        return gameConfig.getUrl(gameType);
    }

    public List<ChatGame> getGamesByChatId(UUID chatId) {
        return repository.findByChatId(chatId);
    }

    public ChatGame createGame(UUID chatId, String gameType, String initialState) {
        Chat chat = chatRepository.findById(chatId)
                .orElseThrow(() -> new IllegalArgumentException("Chat not found: " + chatId));

        ChatGame game = new ChatGame();
        game.setChat(chat);
        game.setGameType(gameType);
        game.setState(initialState);

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
}