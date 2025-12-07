package com.efedotov.meet_now.meet_now.service.chat;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.PageRequest;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import com.efedotov.meet_now.meet_now.dto.response.chat.MessageDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.MessageMediaDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.PaginatedMessagesResponse;
import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserActivityDto;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.Message;
import com.efedotov.meet_now.meet_now.model.chat.MessageMedia;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.content.MessageContentType;
import com.efedotov.meet_now.meet_now.model.content.Sticker;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.chat.ChatRepository;
import com.efedotov.meet_now.meet_now.repository.chat.MessageRepository;
import com.efedotov.meet_now.meet_now.repository.chat.TemporaryChatRepository;
import com.efedotov.meet_now.meet_now.repository.content.MessageContentTypeRepository;
import com.efedotov.meet_now.meet_now.repository.content.StickerRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class WebSocketMessageService {

    private final MessageRepository messageRepository;
    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;
    private final MessageContentTypeRepository contentTypeRepository;
    private final StickerRepository stickerRepository;

    @Transactional
    public MessageDto processMessageDto(MessageDto messageDto) {
        UUID chatId = messageDto.getChatId();
        UUID tempChatId = messageDto.getTempChatId();
        UUID senderId = messageDto.getSenderId();
        UUID recipientId = messageDto.getRecipientId();
        log.info("Пользователь отправил сообщение: от {} к {}, тип: {}, медиафайлов: {}",
                senderId, recipientId, messageDto.getContentType(),
                messageDto.getMedia() != null ? messageDto.getMedia().size() : 0);

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("Sender not found"));
        User recipient = userRepository.findById(recipientId)
                .orElseThrow(() -> new RuntimeException("Recipient not found"));

        Chat chat = null;
        TemporaryChat tempChat = null;
        UUID finalChatId = null;
        boolean isTemporary = false;

        if (chatId != null || tempChatId != null) {
            if (chatId != null) {
                chat = chatRepository.findById(chatId)
                        .orElseThrow(() -> new RuntimeException("Chat not found"));
                finalChatId = chatId;
            } else {
                tempChat = temporaryChatRepository.findById(tempChatId)
                        .orElseThrow(() -> new RuntimeException("Temporary chat not found"));
                finalChatId = tempChatId;
                isTemporary = true;
            }
        } else {
            Optional<Chat> existingChat = chatRepository.findByUser1IdAndUser2Id(senderId, recipientId)
                    .or(() -> chatRepository.findByUser1IdAndUser2Id(recipientId, senderId));

            if (existingChat.isPresent()) {
                chat = existingChat.get();
                chat.setLastMessage(generateLastMessagePreview(messageDto));
                chatRepository.save(chat);
                finalChatId = chat.getChatId();
            } else {
                List<TemporaryChat> tempChats = temporaryChatRepository.findBySenderIdOrRecipientId(senderId,
                        recipientId);
                for (TemporaryChat tchat : tempChats) {
                    if ((tchat.getSender().getId().equals(senderId) && tchat.getRecipient().getId().equals(recipientId))
                            ||
                            (tchat.getSender().getId().equals(recipientId)
                                    && tchat.getRecipient().getId().equals(senderId))) {
                        tempChat = tchat;
                        finalChatId = tchat.getTempChatId();
                        isTemporary = true;
                        break;
                    }
                }

                if (tempChat == null) {
                    tempChat = new TemporaryChat();
                    tempChat.setSender(sender);
                    tempChat.setRecipient(recipient);
                    tempChat.setCreatedAt(LocalDateTime.now());
                    tempChat.setDurationMinutes(5);
                    tempChat.setIsFinished(false);
                    tempChat.setBothAgreed(false);
                    tempChat = temporaryChatRepository.save(tempChat);
                    finalChatId = tempChat.getTempChatId();
                    isTemporary = true;
                }
            }
        }

        Message message = createMessage(sender, recipient, messageDto, chat, tempChat);
        message = messageRepository.save(message);

        if (messageDto.getMedia() != null && !messageDto.getMedia().isEmpty()) {
            saveMessageMedia(message, messageDto.getMedia());
        }

        MessageDto responseDto = createResponseDto(message, finalChatId, isTemporary);

        messagingTemplate.convertAndSendToUser(
                recipient.getUsername(),
                "/queue/messages",
                responseDto);

        log.info("Отправлено сообщение пользователю {}: тип {}, текст {}, медиафайлов {}",
                recipient.getUsername(), responseDto.getContentType(),
                responseDto.getText() != null ? responseDto.getText() : "нет",
                responseDto.getMedia() != null ? responseDto.getMedia().size() : 0);

        return responseDto;
    }

    @Transactional(readOnly = true)
    public PaginatedMessagesResponse getPaginatedMessages(UUID chatId, int page, int size) {
        log.info("Getting paginated messages: chatId={}, page={}, size={}", chatId, page, size);

        boolean isPermanentChat = chatRepository.existsById(chatId);
        boolean isTemporaryChat = temporaryChatRepository.existsById(chatId);

        if (!isPermanentChat && !isTemporaryChat) {
            throw new RuntimeException("Chat not found");
        }

        Page<Message> messagePage;
        long totalMessages;

        if (isPermanentChat) {
            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
            messagePage = messageRepository.findMessagesByChatId(chatId, pageable);
            totalMessages = messageRepository.countByChatId(chatId);
        } else {
            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
            messagePage = messageRepository.findMessagesByTempChatId(chatId, pageable);
            totalMessages = messageRepository.countByTempChatId(chatId);
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

        return response;
    }

    private void saveMessageMedia(Message message, List<MessageMediaDto> mediaDtos) {
        for (int i = 0; i < mediaDtos.size(); i++) {
            MessageMediaDto mediaDto = mediaDtos.get(i);
            MessageMedia media = new MessageMedia();

            if (mediaDto.getContentType() != null) {
                MessageContentType contentType = contentTypeRepository.findByTypeName(mediaDto.getContentType())
                        .orElseThrow(
                                () -> new RuntimeException("Content type not found: " + mediaDto.getContentType()));
                media.setContentType(contentType);
            } else {

                MessageContentType contentType = determineContentType(mediaDto);
                media.setContentType(contentType);
            }

            media.setMediaUrl(mediaDto.getMediaUrl());
            media.setFileSize(mediaDto.getFileSize());
            media.setMimeType(mediaDto.getMimeType());
            media.setThumbnailUrl(mediaDto.getThumbnailUrl());
            media.setSortOrder(i);

            if (mediaDto.getStickerId() != null) {
                Sticker sticker = stickerRepository.findById(mediaDto.getStickerId())
                        .orElseThrow(() -> new RuntimeException("Sticker not found"));
                media.setSticker(sticker);
            }

            message.addMedia(media);
        }

        messageRepository.save(message);
    }

    private MessageContentType determineContentType(MessageMediaDto mediaDto) {
        if (mediaDto.getStickerId() != null) {
            return contentTypeRepository.findByTypeName("sticker")
                    .orElseThrow(() -> new RuntimeException("Sticker content type not found"));
        } else if (mediaDto.getMediaUrl() != null) {
            String mimeType = mediaDto.getMimeType();
            if (mimeType != null) {
                if ("image".equals(mimeType) || mimeType.startsWith("image/")) {
                    return contentTypeRepository.findByTypeName("image")
                            .orElseThrow(() -> new RuntimeException("Image content type not found"));
                } else if ("video".equals(mimeType) || mimeType.startsWith("video/")) {
                    return contentTypeRepository.findByTypeName("video")
                            .orElseThrow(() -> new RuntimeException("Video content type not found"));
                } else {
                    return contentTypeRepository.findByTypeName("file")
                            .orElseThrow(() -> new RuntimeException("File content type not found"));
                }
            }
        }

        return contentTypeRepository.findByTypeName("file")
                .orElseThrow(() -> new RuntimeException("Default file content type not found"));
    }

    private Message createMessage(User sender, User recipient, MessageDto messageDto,
            Chat chat, TemporaryChat tempChat) {
        Message message = new Message();
        message.setSender(sender);
        message.setRecipient(recipient);

        String processedText = messageDto.getText();

        message.setText(processedText);

        message.setCreatedAt(LocalDateTime.now());
        message.setRead(false);

        MessageContentType contentType = determineMessageContentType(messageDto);
        message.setContentType(contentType);

        if (chat != null) {
            message.setChat(chat);
        } else if (tempChat != null) {
            message.setTemporaryChat(tempChat);
        }

        return message;
    }

    private MessageContentType determineMessageContentType(MessageDto messageDto) {
        log.info("🔍 DETERMINE_MESSAGE_CONTENT_TYPE: message contentType={}, media count={}",
                messageDto.getContentType(),
                messageDto.getMedia() != null ? messageDto.getMedia().size() : 0);

        if (messageDto.getContentType() != null && !messageDto.getContentType().equals("text")) {
            String contentType = messageDto.getContentType().toLowerCase();
            log.info("🔍 Используем явный тип сообщения: {}", contentType);

            switch (contentType) {
                case "image" -> {
                    return contentTypeRepository.findByTypeName("image")
                            .orElseThrow(() -> new RuntimeException("Image content type not found"));
                }
                case "video" -> {
                    return contentTypeRepository.findByTypeName("video")
                            .orElseThrow(() -> new RuntimeException("Video content type not found"));
                }
                case "file" -> {
                    return contentTypeRepository.findByTypeName("file")
                            .orElseThrow(() -> new RuntimeException("File content type not found"));
                }
            }
        }

        if (messageDto.getMedia() != null && !messageDto.getMedia().isEmpty()) {
            MessageMediaDto firstMedia = messageDto.getMedia().get(0);
            MessageContentType mediaContentType = determineContentType(firstMedia);
            log.info("🔍 Тип сообщения определен по первому медиа: {}",
                    mediaContentType != null ? mediaContentType.getTypeName() : "null");
            return mediaContentType;
        }

        log.info("🔍 Тип сообщения по умолчанию: text");
        return contentTypeRepository.findByTypeName("text")
                .orElseThrow(() -> new RuntimeException("Default text content type not found"));
    }

    private String generateLastMessagePreview(MessageDto messageDto) {
        if (messageDto.getMedia() != null && !messageDto.getMedia().isEmpty()) {
            if (messageDto.getMedia().stream().anyMatch(m -> m.getStickerId() != null)) {
                return "Стикер";
            } else if (messageDto.getMedia().stream().anyMatch(m -> "image".equals(m.getContentType()))) {
                return messageDto.getMedia().size() > 1 ? "Фотографии (" + messageDto.getMedia().size() + ")" : "Фото";
            } else if (messageDto.getMedia().stream().anyMatch(m -> "video".equals(m.getContentType()))) {
                return messageDto.getMedia().size() > 1 ? "Видео (" + messageDto.getMedia().size() + ")" : "Видео";
            } else if (messageDto.getMedia().stream().anyMatch(m -> "file".equals(m.getContentType()))) {
                return messageDto.getMedia().size() > 1 ? "Файлы (" + messageDto.getMedia().size() + ")" : "Файл";
            }
        }
        return messageDto.getText();
    }

    private MessageDto createResponseDto(Message message, UUID finalChatId, boolean isTemporary) {
        MessageDto dto = new MessageDto();
        dto.setId(message.getId());
        dto.setText(message.getText());
        dto.setCreatedAt(message.getCreatedAt());
        dto.setSenderId(message.getSender().getId());
        dto.setRecipientId(message.getRecipient().getId());
        dto.setRead(message.isRead());

        if (message.getContentType() != null) {
            dto.setContentType(message.getContentType().getTypeName());
        } else {
            dto.setContentType("text");
        }

        if (message.getMedia() != null && !message.getMedia().isEmpty()) {
            dto.setMedia(message.getMedia().stream()
                    .map(this::convertMediaToDto)
                    .collect(Collectors.toList()));
        } else {
            dto.setMedia(new ArrayList<>());
        }

        if (isTemporary) {
            dto.setTempChatId(finalChatId);
        } else {
            dto.setChatId(finalChatId);
        }

        return dto;
    }

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
            dto.setSticker(mapStickerToDto(media.getSticker()));
        }

        return dto;
    }

    private StickerDto mapStickerToDto(Sticker sticker) {
        StickerDto dto = new StickerDto();
        dto.setId(sticker.getId());
        dto.setEmoji(sticker.getEmoji());
        dto.setImageUrl(sticker.getImageUrl());
        return dto;
    }

    public void sendActivityNotification(UserActivityDto activityDto) {
        UUID chatId = activityDto.getChatId();
        String topic = "/topic/chat.activity." + chatId;
        messagingTemplate.convertAndSend(topic, activityDto);
    }

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

    public List<TemporaryChat> getActiveTemporaryChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных временных чатов", userId);
        return chatService.getActiveTemporaryChatsForUser(userId);
    }

    public List<PermanentChatResponseDto> getPermanentChats(UUID userId) {
        log.info("Пользователь: {} запросил список активных постоянных чатов", userId);
        List<Chat> chats = chatService.getPermanentChatsForUser(userId);
        return chats.stream()
                .map(this::convertToPermanentChatDto)
                .collect(Collectors.toList());
    }

    private PermanentChatResponseDto convertToPermanentChatDto(Chat chat) {
        PermanentChatResponseDto dto = new PermanentChatResponseDto();
        dto.setChatId(chat.getChatId());
        dto.setUser1Id(chat.getUser1().getId());
        dto.setUser1Username(chat.getUser1().getUsername());
        dto.setUser1Firstname(chat.getUser1().getFirstname());
        dto.setUser1Subname(chat.getUser1().getSubname());
        dto.setUser1Avatar(chat.getUser1().getAvatar());
        dto.setUser2Id(chat.getUser2().getId());
        dto.setUser2Username(chat.getUser2().getUsername());
        dto.setUser2Firstname(chat.getUser2().getFirstname());
        dto.setUser2Subname(chat.getUser2().getSubname());
        dto.setUser2Avatar(chat.getUser2().getAvatar());
        dto.setCreatedAt(chat.getCreatedAt());
        dto.setIsOpened(chat.getIsOpened());
        dto.setLastMessage(chat.getLastMessage());
        return dto;
    }

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
        } else {
            dto.setContentType("text");
        }

        if (message.getMedia() != null && !message.getMedia().isEmpty()) {
            dto.setMedia(message.getMedia().stream()
                    .map(this::convertMediaToDto)
                    .collect(Collectors.toList()));
        } else {
            dto.setMedia(new ArrayList<>());
        }

        if (message.getChat() != null) {
            dto.setChatId(message.getChat().getChatId());
        }
        if (message.getTemporaryChat() != null) {
            dto.setTempChatId(message.getTemporaryChat().getTempChatId());
        }

        return dto;
    }
}