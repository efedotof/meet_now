package com.efedotov.meet_now.meet_now.service.chat;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.chat.TimerUpdateDto;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatTimerService {

    private final SimpMessagingTemplate messagingTemplate;
    private final TaskScheduler taskScheduler;

    private final Map<UUID, TimerState> timerStates = new ConcurrentHashMap<>();
    private final Map<UUID, ScheduledFuture<?>> updateTasks = new ConcurrentHashMap<>();

    public static class TimerState {
        public LocalDateTime endTime;
        public long remainingMillis;
        public boolean isFinished;
    }

    public void startSynchronizedTimer(TemporaryChat tempChat) {
        UUID tempChatId = tempChat.getTempChatId();

        LocalDateTime endTime = tempChat.getCreatedAt()
                .plusMinutes(tempChat.getDurationMinutes());

        TimerState state = new TimerState();
        state.endTime = endTime;
        state.isFinished = false;
        timerStates.put(tempChatId, state);

        scheduleTimerUpdates(tempChatId, endTime);
    }

    private void scheduleTimerUpdates(UUID tempChatId, LocalDateTime endTime) {
        Instant endInstant = endTime.atZone(ZoneId.systemDefault()).toInstant();

        ScheduledFuture<?> updateTask = taskScheduler.scheduleAtFixedRate(() -> {
            TimerState state = timerStates.get(tempChatId);
            if (state == null)
                return;

            long remaining = Duration.between(Instant.now(), endInstant).toMillis();
            boolean finished = remaining <= 0;

            state.remainingMillis = Math.max(0, remaining);
            state.isFinished = finished;

            TimerUpdateDto updateDto = new TimerUpdateDto();
            updateDto.setTempChatId(tempChatId);
            updateDto.setRemainingTime(state.remainingMillis);
            updateDto.setFinished(finished);

            messagingTemplate.convertAndSend(
                    "/topic/chat/" + tempChatId + "/timer",
                    updateDto);

            if (finished) {
                ScheduledFuture<?> task = updateTasks.remove(tempChatId);
                if (task != null) {
                    task.cancel(false);
                }
                timerStates.remove(tempChatId);
            }
        }, Duration.ofSeconds(1));

        updateTasks.put(tempChatId, updateTask);
    }

    public void addTimeToTimer(UUID tempChatId, int additionalMinutes) {
        TimerState state = timerStates.get(tempChatId);
        if (state == null || state.isFinished) {
            log.warn("Не удалось добавить время: таймер не найден или завершен для чата {}", tempChatId);
            return;
        }

        state.endTime = state.endTime.plusMinutes(additionalMinutes);

        ScheduledFuture<?> oldTask = updateTasks.remove(tempChatId);
        if (oldTask != null) {
            oldTask.cancel(false);
        }

        scheduleTimerUpdates(tempChatId, state.endTime);

        log.info("Добавлено {} минут к таймеру чата {}", additionalMinutes, tempChatId);
    }

    public void stopTimer(UUID tempChatId) {
        ScheduledFuture<?> task = updateTasks.remove(tempChatId);
        if (task != null) {
            task.cancel(false);
        }
        timerStates.remove(tempChatId);
        log.info("Таймер остановлен для чата {}", tempChatId);
    }

    public TimerState getTimerState(UUID tempChatId) {
        return timerStates.get(tempChatId);
    }
}