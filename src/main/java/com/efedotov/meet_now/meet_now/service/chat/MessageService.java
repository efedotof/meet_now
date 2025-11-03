package com.efedotov.meet_now.meet_now.service.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import java.time.LocalDateTime;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;
    private final UserRepository userRepository;

    @Transactional
    public void deleteMessage(UUID messageId, UUID userId, boolean deleteForEveryone) {
        messageRepository.findById(messageId).ifPresent(message -> {
            if (!message.getSender().getId().equals(userId)) {
                throw new IllegalStateException("Только отправитель может удалить сообщение");
            }

            var user = userRepository.findById(userId)
                    .orElseThrow(() -> new IllegalStateException("Пользователь не найден"));

            if (deleteForEveryone) {
                message.setIsDeleted(true);
                message.setDeletedAt(LocalDateTime.now());
                message.setDeletedBy(user);
                log.info("Сообщение {} удалено для всех пользователей", messageId);
            } else {
                message.setIsDeleted(true);
                message.setDeletedAt(LocalDateTime.now());
                message.setDeletedBy(user);
                log.info("Сообщение {} удалено для отправителя", messageId);
            }

            messageRepository.save(message);
        });
    }

    @Transactional
    public void restoreMessage(UUID messageId, UUID userId) {
        messageRepository.findById(messageId).ifPresent(message -> {
            if (!message.getSender().getId().equals(userId)) {
                throw new IllegalStateException("Только отправитель может восстановить сообщение");
            }

            message.setIsDeleted(false);
            message.setDeletedAt(null);
            message.setDeletedBy(null);

            messageRepository.save(message);
            log.info("Сообщение {} восстановлено", messageId);
        });
    }
}