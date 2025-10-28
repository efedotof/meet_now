package com.efedotov.meet_now.meet_now.service.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatTimerManagementService {

    private final ChatTimerService chatTimerService;
    private final TemporaryChatService temporaryChatService;

    public void startSynchronizedTimer(UUID tempChatId) {
        var tempChat = temporaryChatService.findById(tempChatId);
        if (tempChat.isPresent()) {
            chatTimerService.startSynchronizedTimer(tempChat.get());
        } else {
            log.warn("Не удалось запустить таймер: временный чат {} не найден", tempChatId);
        }
    }

    public void addTimeToTimer(UUID tempChatId, int additionalMinutes) {
        chatTimerService.addTimeToTimer(tempChatId, additionalMinutes);
    }

    public void stopTimer(UUID tempChatId) {
        chatTimerService.stopTimer(tempChatId);
    }
}