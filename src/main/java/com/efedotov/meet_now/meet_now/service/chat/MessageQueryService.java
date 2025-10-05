package com.efedotov.meet_now.meet_now.service.chat;

import com.efedotov.meet_now.meet_now.dto.response.chat.MessageDto;
import com.efedotov.meet_now.meet_now.model.chat.Message;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageQueryService {

    private final MessageRepository messageRepository;
    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public void sendMessagesForChatToUser(UUID chatId, String username) {
        List<Message> messages;
        log.info("Запрос пользователя {} на получение сообщений чата {}", username, chatId);

        if (chatRepository.existsById(chatId)) {
            messages = messageRepository.findByChat_ChatIdOrderByCreatedAtAsc(chatId);
            log.info("Пользователь {} запросил сообщения из обычного чата {}", username, chatId);
        } else if (temporaryChatRepository.existsById(chatId)) {
            messages = messageRepository.findByTemporaryChat_TempChatIdOrderByCreatedAtAsc(chatId);
            log.info("Пользователь {} запросил сообщения из временного чата {}", username, chatId);
        } else {
            log.warn("Чат с ID {} не найден для пользователя {}", chatId, username);
            return;
        }

        List<MessageDto> dtos = messages.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.messages",
                dtos);
    }

    private MessageDto convertToDto(Message message) {
        MessageDto dto = new MessageDto();
        dto.setId(message.getId());
        dto.setText(message.getText());
        dto.setCreatedAt(message.getCreatedAt());
        dto.setSenderId(message.getSender().getId());
        dto.setRecipientId(message.getRecipient().getId());
        dto.setRead(message.isRead());
        if (message.getChat() != null) {
            dto.setChatId(message.getChat().getChatId());
        }
        if (message.getTemporaryChat() != null) {
            dto.setTempChatId(message.getTemporaryChat().getTempChatId());
        }

        return dto;
    }
}