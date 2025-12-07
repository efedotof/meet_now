package com.efedotov.meet_now.meet_now.service.chat;

import com.efedotov.meet_now.meet_now.dto.response.chat.MessageDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.MessageMediaDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.PaginatedMessagesResponse;
import com.efedotov.meet_now.meet_now.model.chat.Message;
import com.efedotov.meet_now.meet_now.model.chat.MessageMedia;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;

import org.springframework.data.domain.PageRequest;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
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

    @Transactional(readOnly = true)
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

        log.info("Отправлено {} сообщений пользователю {}", dtos.size(), username);

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.messages",
                dtos);
    }

    @Transactional(readOnly = true)
    public PaginatedMessagesResponse getPaginatedMessagesForChat(UUID chatId, int page, int size) {
        log.info("Getting paginated messages for chatId={}, page={}, size={}", chatId, page, size);

        boolean isPermanentChat = chatRepository.existsById(chatId);
        boolean isTemporaryChat = temporaryChatRepository.existsById(chatId);

        if (!isPermanentChat && !isTemporaryChat) {
            throw new RuntimeException("Chat not found with id: " + chatId);
        }

        Page<Message> messagePage;
        long totalMessages;

        if (isPermanentChat) {
            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
            messagePage = messageRepository.findMessagesByChatId(chatId, pageable);
            totalMessages = messageRepository.countNonDeletedByChatId(chatId);
        } else {
            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
            messagePage = messageRepository.findMessagesByTempChatId(chatId, pageable);
            totalMessages = messageRepository.countNonDeletedByTempChatId(chatId);
        }

        List<Message> messages = new ArrayList<>(messagePage.getContent());
        Collections.reverse(messages);

        List<MessageDto> dtos = messages.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());

        PaginatedMessagesResponse response = new PaginatedMessagesResponse();
        response.setMessages(dtos);
        response.setCurrentPage(page);
        response.setTotalPages(messagePage.getTotalPages());
        response.setTotalMessages((int) totalMessages);
        response.setHasNext(messagePage.hasNext());

        log.info("Returning {} messages for chatId={}, page={}/{}, hasNext={}",
                dtos.size(), chatId, page, response.getTotalPages(), response.isHasNext());

        return response;
    }

    @Transactional(readOnly = true)
    private MessageDto convertToDto(Message message) {
        MessageDto dto = new MessageDto();
        dto.setId(message.getId());
        dto.setText(message.getText());
        dto.setCreatedAt(message.getCreatedAt());
        dto.setSenderId(message.getSender().getId());
        dto.setRecipientId(message.getRecipient().getId());
        dto.setRead(message.isRead());

        if (message.getContentType() != null) {
            dto.setContentType(message.getContentType().getTypeName());
            log.info("🔍 MESSAGE_QUERY_SERVICE: Сообщение {} имеет тип контента: {}",
                    message.getId(), message.getContentType().getTypeName());
        } else {
            dto.setContentType("text");
            log.info("🔍 MESSAGE_QUERY_SERVICE: Сообщение {} имеет тип контента по умолчанию: text",
                    message.getId());
        }

        if (message.getMedia() != null && !message.getMedia().isEmpty()) {
            dto.setMedia(message.getMedia().stream()
                    .map(this::convertMediaToDto)
                    .collect(Collectors.toList()));
            log.info("🔍 MESSAGE_QUERY_SERVICE: Сообщение {} имеет {} медиафайлов",
                    message.getId(), message.getMedia().size());
        } else {
            dto.setMedia(new ArrayList<>());
            log.info("🔍 MESSAGE_QUERY_SERVICE: Сообщение {} не имеет медиафайлов",
                    message.getId());
        }

        if (message.getChat() != null) {
            dto.setChatId(message.getChat().getChatId());
        }
        if (message.getTemporaryChat() != null) {
            dto.setTempChatId(message.getTemporaryChat().getTempChatId());
        }

        return dto;
    }

    @Transactional(readOnly = true)
    private MessageMediaDto convertMediaToDto(MessageMedia media) {
        MessageMediaDto dto = new MessageMediaDto();
        dto.setId(media.getId());

        if (media.getContentType() != null) {
            dto.setContentType(media.getContentType().getTypeName());
        } else {
            dto.setContentType("file");
        }

        dto.setMediaUrl(media.getMediaUrl());
        dto.setFileSize(media.getFileSize());
        dto.setMimeType(media.getMimeType());
        dto.setThumbnailUrl(media.getThumbnailUrl());
        dto.setSortOrder(media.getSortOrder());

        if (media.getSticker() != null) {
            dto.setStickerId(media.getSticker().getId());
        }

        return dto;
    }
}