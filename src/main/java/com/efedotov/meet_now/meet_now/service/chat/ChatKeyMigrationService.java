package com.efedotov.meet_now.meet_now.service.chat;

import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class ChatKeyMigrationService {

    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final RsaCryptoService rsaCryptoService;

    private static final boolean MIGRATION_ENABLED = true;

    @EventListener(ApplicationReadyEvent.class)
    public void migrateExistingChats() {
        if (!MIGRATION_ENABLED)
            return;

        log.info("Миграция: генерация AES-ключей для существующих чатов");

        // 1. Постоянные чаты
        List<Chat> permanentChats = chatRepository.findAll();
        for (Chat chat : permanentChats) {
            if (chat.getEncryptedAesKeyForUser1() == null || chat.getEncryptedAesKeyForUser2() == null) {
                generateAndStoreKeysForChat(chat);
            }
        }

        // 2. Временные чаты
        List<TemporaryChat> temporaryChats = temporaryChatRepository.findAll();
        for (TemporaryChat tempChat : temporaryChats) {
            if (tempChat.getEncryptedAesKeyForSender() == null || tempChat.getEncryptedAesKeyForRecipient() == null) {
                generateAndStoreKeysForTemporaryChat(tempChat);
            }
        }

        log.info("Миграция завершена");
    }

    private void generateAndStoreKeysForChat(Chat chat) {
        try {
            User user1 = chat.getUser1();
            User user2 = chat.getUser2();
            if (user1.getPublicKey() == null || user2.getPublicKey() == null) {
                log.warn("Пропущен чат {}: отсутствует публичный ключ одного из участников", chat.getChatId());
                return;
            }

            byte[] aesKey = new byte[32];
            new SecureRandom().nextBytes(aesKey);
            String base64AesKey = Base64.getEncoder().encodeToString(aesKey);

            String encForUser1 = rsaCryptoService.encrypt(base64AesKey, user1.getPublicKey());
            String encForUser2 = rsaCryptoService.encrypt(base64AesKey, user2.getPublicKey());

            chat.setEncryptedAesKeyForUser1(encForUser1);
            chat.setEncryptedAesKeyForUser2(encForUser2);
            chatRepository.save(chat);
            log.info("AES-ключи сгенерированы для чата {}", chat.getChatId());
        } catch (Exception e) {
            log.error("Ошибка при генерации ключей для чата {}: {}", chat.getChatId(), e.getMessage());
        }
    }

    private void generateAndStoreKeysForTemporaryChat(TemporaryChat tempChat) {
        try {
            User sender = tempChat.getSender();
            User recipient = tempChat.getRecipient();
            if (sender.getPublicKey() == null || recipient.getPublicKey() == null) {
                log.warn("Пропущен временный чат {}: отсутствует публичный ключ участника", tempChat.getTempChatId());
                return;
            }

            byte[] aesKey = new byte[32];
            new SecureRandom().nextBytes(aesKey);
            String base64AesKey = Base64.getEncoder().encodeToString(aesKey);

            String encForSender = rsaCryptoService.encrypt(base64AesKey, sender.getPublicKey());
            String encForRecipient = rsaCryptoService.encrypt(base64AesKey, recipient.getPublicKey());

            tempChat.setEncryptedAesKeyForSender(encForSender);
            tempChat.setEncryptedAesKeyForRecipient(encForRecipient);
            temporaryChatRepository.save(tempChat);
            log.info("AES-ключи сгенерированы для временного чата {}", tempChat.getTempChatId());
        } catch (Exception e) {
            log.error("Ошибка при генерации ключей для временного чата {}: {}", tempChat.getTempChatId(),
                    e.getMessage());
        }
    }
}