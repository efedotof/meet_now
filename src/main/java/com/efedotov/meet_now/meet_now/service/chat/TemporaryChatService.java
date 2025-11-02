package com.efedotov.meet_now.meet_now.service.chat;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class TemporaryChatService {

    private final TemporaryChatRepository temporaryChatRepository;
    private final ApplicationEventPublisher eventPublisher;

    public Optional<TemporaryChat> findById(UUID tempChatId) {
        return temporaryChatRepository.findById(tempChatId);
    }

    public List<TemporaryChat> findActiveChats() {
        return temporaryChatRepository.findByIsFinishedFalse();
    }

    public TemporaryChat save(TemporaryChat temporaryChat) {
        TemporaryChat savedChat = temporaryChatRepository.save(temporaryChat);

        if (!savedChat.getIsFinished()) {
            eventPublisher.publishEvent(new TemporaryChatCreatedEvent(savedChat));
        }

        return savedChat;
    }

    @Transactional
    public void finishTemporaryChat(UUID tempChatId) {
        temporaryChatRepository.findById(tempChatId).ifPresent(chat -> {
            chat.setIsFinished(true);
            temporaryChatRepository.save(chat);
            log.info("Временный чат {} помечен как завершенный", tempChatId);
            temporaryChatRepository.delete(chat);
            log.info("Временный чат {} удален из базы данных", tempChatId);
        });
    }

    @Transactional
    public void deleteTemporaryChat(UUID tempChatId) {
        temporaryChatRepository.deleteById(tempChatId);
        log.info("Временный чат {} удален из базы данных", tempChatId);
    }

    public boolean existsById(UUID tempChatId) {
        return temporaryChatRepository.existsById(tempChatId);
    }

    public static class TemporaryChatCreatedEvent {
        private final TemporaryChat temporaryChat;

        public TemporaryChatCreatedEvent(TemporaryChat temporaryChat) {
            this.temporaryChat = temporaryChat;
        }

        public TemporaryChat getTemporaryChat() {
            return temporaryChat;
        }
    }
}