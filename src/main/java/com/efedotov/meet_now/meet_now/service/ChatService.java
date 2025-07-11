package com.efedotov.meet_now.meet_now.service;

import com.efedotov.meet_now.meet_now.model.*;
import com.efedotov.meet_now.meet_now.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final ChatConstraintRepository chatConstraintRepository;
    private final ChatGameRepository chatGameRepository;

    private final TaskScheduler taskScheduler;
    private final Map<UUID, ScheduledFuture<?>> tempChatTimers = new ConcurrentHashMap<>();

    /**
     * Создать временный чат между двумя пользователями.
     * Запускает таймер на ограниченную длительность.
     */
    @Transactional
    public TemporaryChat createTemporaryChat(User sender, User recipient, int durationMinutes) {
        TemporaryChat tempChat = new TemporaryChat();
        tempChat.setSender(sender);
        tempChat.setRecipient(recipient);
        tempChat.setCreatedAt(LocalDateTime.now());
        tempChat.setDurationMinutes(durationMinutes);
        tempChat.setIsFinished(false);
        tempChat.setBothAgreed(false);

        temporaryChatRepository.save(tempChat);

        // Создаем ограничение (constraint) с начальным временем ожидания (например, 30
        // сек)
        ChatConstraint constraint = new ChatConstraint();
        constraint.setTemporaryChat(tempChat);
        constraint.setWaitSeconds(30);
        constraint.setCanStart(false);
        chatConstraintRepository.save(constraint);

        scheduleTempChatTimeout(tempChat);

        return tempChat;
    }

    /**
     * Запускает таймер, который по окончании durationMinutes завершит временный
     * чат.
     */
    private void scheduleTempChatTimeout(TemporaryChat tempChat) {
        Runnable task = () -> finishTemporaryChat(tempChat.getTempChatId());

        Instant scheduledInstant = tempChat.getCreatedAt()
                .plusMinutes(tempChat.getDurationMinutes())
                .atZone(ZoneId.systemDefault())
                .toInstant();

        ScheduledFuture<?> scheduledTask = taskScheduler.schedule(task, scheduledInstant);
        tempChatTimers.put(tempChat.getTempChatId(), scheduledTask);
        log.info("Таймер для TemporaryChat {} установлен на {} минут", tempChat.getTempChatId(),
                tempChat.getDurationMinutes());
    }

    /**
     * Завершить временный чат: выставить флаг isFinished = true, удалить таймер.
     * Если оба участника согласны, создается постоянный чат.
     */
    @Transactional
    public void finishTemporaryChat(UUID tempChatId) {
        temporaryChatRepository.findById(tempChatId).ifPresent(tempChat -> {
            if (!tempChat.getIsFinished()) {
                tempChat.setIsFinished(true);
                temporaryChatRepository.save(tempChat);
                log.info("TemporaryChat {} завершен", tempChatId);

                // Удаляем таймер
                ScheduledFuture<?> scheduledTask = tempChatTimers.remove(tempChatId);
                if (scheduledTask != null) {
                    scheduledTask.cancel(false);
                }

                // Если оба согласны, создаем постоянный чат и открываем анкеты
                if (Boolean.TRUE.equals(tempChat.getBothAgreed())) {
                    createPermanentChatFromTemporary(tempChat);
                }
            }
        });
    }

    /**
     * Создает постоянный чат из временного и открывает анкеты (isOpened = true)
     */
    @Transactional
    protected void createPermanentChatFromTemporary(TemporaryChat tempChat) {
        Optional<Chat> existingChat = chatRepository.findByUser1IdAndUser2Id(
                tempChat.getSender().getId(), tempChat.getRecipient().getId());

        if (existingChat.isEmpty()) {
            Chat chat = new Chat();
            chat.setUser1(tempChat.getSender());
            chat.setUser2(tempChat.getRecipient());
            chat.setCreatedAt(LocalDateTime.now());
            chat.setIsOpened(true);
            chatRepository.save(chat);

            log.info("Создан постоянный чат между {} и {}",
                    tempChat.getSender().getId(), tempChat.getRecipient().getId());
        } else {
            // Если чат уже существует — обновляем флаг isOpened, если нужно
            Chat chat = existingChat.get();
            if (!Boolean.TRUE.equals(chat.getIsOpened())) {
                chat.setIsOpened(true);
                chatRepository.save(chat);
                log.info("Чат {} открыт (isOpened = true)", chat.getChatId());
            }
        }
    }

    /**
     * Пользователь соглашается на продолжение общения.
     * Если оба согласны, отмечаем это в TemporaryChat.
     */
    @Transactional
    public void agreeToContinue(UUID tempChatId, UUID userId) {
        temporaryChatRepository.findById(tempChatId).ifPresent(tempChat -> {
            boolean changed = false;
            if (tempChat.getSender().getId().equals(userId) && !Boolean.TRUE.equals(tempChat.getBothAgreed())) {
                // Для простоты считаем, что оба согласны если вызвали метод дважды от двух
                // разных юзеров
                if (tempChat.getBothAgreed() == null || !tempChat.getBothAgreed()) {
                    tempChat.setBothAgreed(true);
                    changed = true;
                }
            } else if (tempChat.getRecipient().getId().equals(userId)) {
                if (tempChat.getBothAgreed() == null || !tempChat.getBothAgreed()) {
                    tempChat.setBothAgreed(true);
                    changed = true;
                }
            }
            if (changed) {
                temporaryChatRepository.save(tempChat);
                log.info("Пользователь {} согласился продолжить чат {}", userId, tempChatId);
            }
        });
    }

    /**
     * Получить все активные (не завершённые) временные чаты для пользователя
     */
    public List<TemporaryChat> getActiveTemporaryChatsForUser(UUID userId) {
        return temporaryChatRepository.findByIsFinishedFalse().stream()
                .filter(tc -> tc.getSender().getId().equals(userId) || tc.getRecipient().getId().equals(userId))
                .toList();
    }

    /**
     * Получить все постоянные чаты пользователя.
     */
    public List<Chat> getPermanentChatsForUser(UUID userId) {
        return chatRepository.findByUser1IdOrUser2Id(userId, userId);
    }

    /**
     * Логика по обновлению ограничения (например, можно ли начать чат).
     * Можно расширять под бизнес-логику.
     */
    @Transactional
    public void updateChatConstraint(UUID tempChatId, boolean canStart, int waitSeconds) {
        chatConstraintRepository.findByTemporaryChat_TempChatId(tempChatId).ifPresent(constraint -> {
            constraint.setCanStart(canStart);
            constraint.setWaitSeconds(waitSeconds);
            chatConstraintRepository.save(constraint);
            log.info("Обновлено ограничение для временного чата {}", tempChatId);
        });
    }

    /**
     * Получить ограничения для временного чата
     */
    public Optional<ChatConstraint> getChatConstraint(UUID tempChatId) {
        return chatConstraintRepository.findByTemporaryChat_TempChatId(tempChatId);
    }

    /**
     * Добавить или получить игры для чата
     */
    public List<ChatGame> getChatGames(UUID chatId) {
        return chatGameRepository.findByChat_ChatId(chatId);
    }

    public ChatGame addGameToChat(UUID chatId, String gameType, String initialState) {
        ChatGame game = new ChatGame();
        Chat chat = chatRepository.findById(chatId)
                .orElseThrow(() -> new IllegalArgumentException("Чат не найден: " + chatId));
        game.setChat(chat);
        game.setGameType(gameType);
        game.setState(initialState);
        chatGameRepository.save(game);
        return game;
    }
}
