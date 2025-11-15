package com.efedotov.meet_now.meet_now.service.chat;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.dto.response.chat.ChatStatisticsAdmin;
import com.efedotov.meet_now.meet_now.dto.response.chat.UserChatsResponse;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.ChatConstraint;
import com.efedotov.meet_now.meet_now.model.chat.ChatGame;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatConstraintRepository;
import com.efedotov.meet_now.meet_now.repository.chat.ChatGameRepository;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final ChatConstraintRepository chatConstraintRepository;
    private final ChatGameRepository chatGameRepository;
    private final UserRepository userRepository;
    private final ChatTimerManagementService chatTimerManagementService;

    @AdminOnly
    @Transactional(readOnly = true)
    public List<TemporaryChat> getAllTemporaryChats() {
        return temporaryChatRepository.findAll();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<Chat> getAllPermanentChats() {
        return chatRepository.findAll();
    }

    @AdminOnly
    @Transactional
    public void adminDeletePermanentChat(UUID chatId) {
        chatRepository.findById(chatId).ifPresent(chat -> {
            chat.setDeletedByUser1(true);
            chat.setDeletedByUser2(true);
            chat.setDeletedAt(LocalDateTime.now());
            chat.setIsOpened(false);
            chatRepository.save(chat);
            log.info("Администратор удалил постоянный чат {}", chatId);
        });
    }

    @AdminOnly
    @Transactional
    public void adminDeleteTemporaryChat(UUID tempChatId) {
        temporaryChatRepository.findById(tempChatId).ifPresent(tempChat -> {
            tempChat.setDeletedBySender(true);
            tempChat.setDeletedByRecipient(true);
            tempChat.setDeletedAt(LocalDateTime.now());
            tempChat.setIsFinished(true);
            temporaryChatRepository.save(tempChat);
            log.info("Администратор удалил временный чат {}", tempChatId);
        });
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public ChatStatisticsAdmin getChatStatistics() {
        ChatStatisticsAdmin stats = new ChatStatisticsAdmin();

        long totalPermanentChats = chatRepository.count();
        long totalTemporaryChats = temporaryChatRepository.count();
        long activeTemporaryChats = temporaryChatRepository.countByIsFinishedFalse();
        long activePermanentChats = chatRepository.countByIsOpenedTrue();
        long deletedPermanentChats = chatRepository.countByDeletedByUser1TrueOrDeletedByUser2True();

        stats.setTotalPermanentChats(totalPermanentChats);
        stats.setTotalTemporaryChats(totalTemporaryChats);
        stats.setActiveTemporaryChats(activeTemporaryChats);
        stats.setActivePermanentChats(activePermanentChats);
        stats.setDeletedPermanentChats(deletedPermanentChats);

        return stats;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public UserChatsResponse getUserChats(UUID userId) {
        UserChatsResponse response = new UserChatsResponse();

        List<Chat> permanentChats = chatRepository.findByUser1IdOrUser2Id(userId, userId);
        List<TemporaryChat> temporaryChats = temporaryChatRepository.findBySenderIdOrRecipientId(userId, userId);

        response.setUserId(userId);
        response.setPermanentChats(permanentChats);
        response.setTemporaryChats(temporaryChats);
        response.setTotalPermanentChats(permanentChats.size());
        response.setTotalTemporaryChats(temporaryChats.size());

        return response;
    }

    public Optional<User> getUserById(UUID userId) {
        return userRepository.findById(userId);
    }

    public Optional<TemporaryChat> getTemporaryChatById(UUID tempChatId) {
        return temporaryChatRepository.findById(tempChatId);
    }

    @Transactional
    public TemporaryChat createTemporaryChat(User sender, User recipient, int durationMinutes) {
        log.info("Создание временного чата между {} и {}", sender.getUsername(), recipient.getUsername());

        if (!sender.getIsSearching() || !recipient.getIsSearching()) {
            log.error("Один из пользователей больше не в поиске: {}={}, {}={}",
                    sender.getUsername(), sender.getIsSearching(),
                    recipient.getUsername(), recipient.getIsSearching());
            throw new IllegalStateException("One of users is no longer searching");
        }

        TemporaryChat tempChat = new TemporaryChat();
        tempChat.setSender(sender);
        tempChat.setRecipient(recipient);
        tempChat.setCreatedAt(LocalDateTime.now());
        tempChat.setDurationMinutes(durationMinutes);
        tempChat.setIsFinished(false);
        tempChat.setBothAgreed(false);

        temporaryChatRepository.save(tempChat);

        ChatConstraint constraint = new ChatConstraint();
        constraint.setTemporaryChat(tempChat);
        constraint.setWaitSeconds(30);
        constraint.setCanStart(false);
        chatConstraintRepository.save(constraint);

        sender.setIsSearching(false);
        recipient.setIsSearching(false);

        userRepository.save(sender);
        userRepository.save(recipient);

        log.info("Пользователи вышли из режима поиска: {} и {}", sender.getUsername(), recipient.getUsername());

        chatTimerManagementService.startSynchronizedTimer(tempChat.getTempChatId());

        return tempChat;
    }

    @Transactional
    public void finishTemporaryChat(UUID tempChatId) {
        temporaryChatRepository.findById(tempChatId).ifPresent(tempChat -> {
            if (!tempChat.getIsFinished()) {
                tempChat.setIsFinished(true);
                temporaryChatRepository.save(tempChat);

                User sender = tempChat.getSender();
                User recipient = tempChat.getRecipient();
                sender.setIsSearching(false);
                recipient.setIsSearching(false);
                userRepository.save(sender);
                userRepository.save(recipient);

                chatTimerManagementService.stopTimer(tempChatId);

                log.info("TemporaryChat {} завершен", tempChatId);

                if (Boolean.TRUE.equals(tempChat.getBothAgreed())) {
                    createPermanentChatFromTemporary(tempChat);
                }
            }
        });
    }

    public Optional<Chat> getPermanentChatById(UUID chatId) {
        return chatRepository.findById(chatId);
    }

    @Transactional
    public Chat createPermanentChatFromTemporary(TemporaryChat tempChat) {
        Optional<Chat> existingChat = chatRepository.findByUser1IdAndUser2Id(
                tempChat.getSender().getId(), tempChat.getRecipient().getId());

        Chat chat;
        if (existingChat.isEmpty()) {
            chat = new Chat();
            chat.setUser1(tempChat.getSender());
            chat.setUser2(tempChat.getRecipient());
            chat.setCreatedAt(LocalDateTime.now());
            chat.setIsOpened(true);
            chatRepository.save(chat);

            log.info("Создан постоянный чат между {} и {}",
                    tempChat.getSender().getId(), tempChat.getRecipient().getId());
        } else {
            chat = existingChat.get();
            if (!Boolean.TRUE.equals(chat.getIsOpened())) {
                chat.setIsOpened(true);
                chatRepository.save(chat);
                log.info("Чат {} открыт (isOpened = true)", chat.getChatId());
            }
        }

        tempChat.setIsFinished(true);
        temporaryChatRepository.save(tempChat);
        chatTimerManagementService.stopTimer(tempChat.getTempChatId());

        return chat;
    }

    @Transactional
    public void agreeToContinue(UUID tempChatId, UUID userId) {
        temporaryChatRepository.findById(tempChatId).ifPresent(tempChat -> {
            boolean changed = false;

            if (!tempChat.getSender().getId().equals(userId) &&
                    !tempChat.getRecipient().getId().equals(userId)) {
                throw new IllegalStateException("Пользователь не является участником чата");
            }

            if (Boolean.TRUE.equals(tempChat.getIsFinished())) {
                throw new IllegalStateException("Чат уже завершен");
            }

            if (tempChat.getBothAgreed() == null || !tempChat.getBothAgreed()) {
                tempChat.setBothAgreed(true);
                changed = true;
                log.info("Пользователь {} согласился продолжить чат {}", userId, tempChatId);
            }

            if (changed) {
                temporaryChatRepository.save(tempChat);
            }
        });
    }

    @Transactional
    public void updateChatConstraint(UUID tempChatId, boolean canStart, int waitSeconds) {
        chatConstraintRepository.findByTemporaryChat_TempChatId(tempChatId).ifPresent(constraint -> {
            constraint.setCanStart(canStart);
            constraint.setWaitSeconds(waitSeconds);
            chatConstraintRepository.save(constraint);
            log.info("Обновлено ограничение для временного чата {}", tempChatId);
        });
    }

    public Optional<ChatConstraint> getChatConstraint(UUID tempChatId) {
        return chatConstraintRepository.findByTemporaryChat_TempChatId(tempChatId);
    }

    public List<ChatGame> getChatGames(UUID chatId) {
        return chatGameRepository.findByChatId(chatId);
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

    @Transactional
    public void deletePermanentChat(UUID chatId, UUID userId, boolean deleteForBoth) {
        chatRepository.findById(chatId).ifPresent(chat -> {
            if (!isUserParticipant(chat, userId)) {
                throw new IllegalStateException("Пользователь не является участником чата");
            }

            if (deleteForBoth) {
                chat.setDeletedByUser1(true);
                chat.setDeletedByUser2(true);
                chat.setDeletedAt(LocalDateTime.now());
                log.info("Чат {} удален для обоих пользователей", chatId);
            } else {
                if (chat.getUser1().getId().equals(userId)) {
                    chat.setDeletedByUser1(true);
                } else if (chat.getUser2().getId().equals(userId)) {
                    chat.setDeletedByUser2(true);
                }
                chat.setDeletedAt(LocalDateTime.now());
                log.info("Чат {} удален для пользователя {}", chatId, userId);
            }

            chatRepository.save(chat);
        });
    }

    @Transactional
    public void deleteTemporaryChat(UUID tempChatId, UUID userId, boolean deleteForBoth) {
        temporaryChatRepository.findById(tempChatId).ifPresent(tempChat -> {
            if (!isUserParticipant(tempChat, userId)) {
                throw new IllegalStateException("Пользователь не является участником временного чата");
            }

            if (deleteForBoth) {
                tempChat.setDeletedBySender(true);
                tempChat.setDeletedByRecipient(true);
                tempChat.setDeletedAt(LocalDateTime.now());
                log.info("Временный чат {} удален для обоих пользователей", tempChatId);
            } else {
                if (tempChat.getSender().getId().equals(userId)) {
                    tempChat.setDeletedBySender(true);
                } else if (tempChat.getRecipient().getId().equals(userId)) {
                    tempChat.setDeletedByRecipient(true);
                }
                tempChat.setDeletedAt(LocalDateTime.now());
                log.info("Временный чат {} удален для пользователя {}", tempChatId, userId);
            }

            temporaryChatRepository.save(tempChat);
        });
    }

    @Transactional
    public void restorePermanentChat(UUID chatId, UUID userId) {
        chatRepository.findById(chatId).ifPresent(chat -> {
            if (!isUserParticipant(chat, userId)) {
                throw new IllegalStateException("Пользователь не является участником чата");
            }

            if (chat.getUser1().getId().equals(userId)) {
                chat.setDeletedByUser1(false);
            } else if (chat.getUser2().getId().equals(userId)) {
                chat.setDeletedByUser2(false);
            }

            if (!chat.getDeletedByUser1() && !chat.getDeletedByUser2()) {
                chat.setDeletedAt(null);
            }

            chatRepository.save(chat);
            log.info("Чат {} восстановлен для пользователя {}", chatId, userId);
        });
    }

    public List<Chat> getDeletedChatsForUser(UUID userId) {
        return chatRepository.findDeletedChatsByUserId(userId);
    }

    public List<TemporaryChat> getActiveTemporaryChatsForUser(UUID userId) {
        return temporaryChatRepository.findByIsFinishedFalse().stream()
                .filter(tc -> (tc.getSender().getId().equals(userId) && !Boolean.TRUE.equals(tc.getDeletedBySender()))
                        ||
                        (tc.getRecipient().getId().equals(userId) && !Boolean.TRUE.equals(tc.getDeletedByRecipient())))
                .toList();
    }

    public List<Chat> getPermanentChatsForUser(UUID userId) {
        return chatRepository.findNonDeletedChatsByUserId(userId);
    }

    private boolean isUserParticipant(Chat chat, UUID userId) {
        return chat.getUser1().getId().equals(userId) || chat.getUser2().getId().equals(userId);
    }

    private boolean isUserParticipant(TemporaryChat tempChat, UUID userId) {
        return tempChat.getSender().getId().equals(userId) || tempChat.getRecipient().getId().equals(userId);
    }

}