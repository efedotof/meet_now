package com.efedotov.meet_now.meet_now.service.chat;

import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TemporaryChatService {

    private final TemporaryChatRepository temporaryChatRepository;

    public Optional<TemporaryChat> findById(UUID tempChatId) {
        return temporaryChatRepository.findById(tempChatId);
    }

    public TemporaryChat save(TemporaryChat temporaryChat) {
        return temporaryChatRepository.save(temporaryChat);
    }
}