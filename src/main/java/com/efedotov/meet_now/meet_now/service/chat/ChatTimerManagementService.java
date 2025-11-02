package com.efedotov.meet_now.meet_now.service.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.service.chat.ChatTimerService.TimerState;

import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatTimerManagementService {

    private final ChatTimerService chatTimerService;
    private final TemporaryChatService temporaryChatService;

    @EventListener
    public void handleTemporaryChatCreated(TemporaryChatService.TemporaryChatCreatedEvent event) {
        TemporaryChat tempChat = event.getTemporaryChat();
        log.info("Получено событие создания чата: {}", tempChat.getTempChatId());
        initializeTimerForNewChat(tempChat);
    }

    public void initializeTimerForNewChat(TemporaryChat tempChat) {
        log.info("Инициализация таймера для нового чата: {}", tempChat.getTempChatId());
        chatTimerService.startSynchronizedTimer(tempChat);
    }

    @EventListener(ApplicationReadyEvent.class)
    public void initializeAllActiveChatTimers() {
        log.info("Инициализация таймеров для всех активных чатов");
        List<TemporaryChat> activeChats = temporaryChatService.findActiveChats();
        for (TemporaryChat chat : activeChats) {
            if (!chat.getIsFinished()) {
                chatTimerService.startSynchronizedTimer(chat);
                log.info("Таймер запущен для чата: {}", chat.getTempChatId());
            }
        }
    }

    public void addTimeToTimer(UUID tempChatId, int additionalMinutes) {
        TimerState existingState = chatTimerService.getTimerState(tempChatId);
        if (existingState == null) {
            var tempChat = temporaryChatService.findById(tempChatId);
            if (tempChat.isPresent()) {
                chatTimerService.startSynchronizedTimer(tempChat.get());
                log.info("Таймер создан для чата {} перед добавлением времени", tempChatId);
            } else {
                log.warn("Не удалось добавить время: чат {} не найден", tempChatId);
                return;
            }
        }

        chatTimerService.addTimeToTimer(tempChatId, additionalMinutes);
    }

    public void startSynchronizedTimer(UUID tempChatId) {
        var tempChat = temporaryChatService.findById(tempChatId);
        if (tempChat.isPresent()) {
            chatTimerService.startSynchronizedTimer(tempChat.get());
        } else {
            log.warn("Не удалось запустить таймер: временный чат {} не найден", tempChatId);
        }
    }

    public void stopTimer(UUID tempChatId) {
        chatTimerService.stopTimer(tempChatId);
    }
}