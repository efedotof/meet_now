package com.efedotov.meet_now.meet_now.service.chat;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.chat.MessageDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.MessageMediaDto;
import com.efedotov.meet_now.meet_now.dto.response.content.StickerDto;
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
import com.efedotov.meet_now.meet_now.service.notification.InternalNotificationService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageProcessingService {

    private final MessageRepository messageRepository;
    private final ChatRepository chatRepository;
    private final TemporaryChatRepository temporaryChatRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;
    private final MessageContentTypeRepository contentTypeRepository;
    private final StickerRepository stickerRepository;
    private final PermanentChatUpdateService permanentChatUpdateService;
    private final InternalNotificationService internalNotificationService;

    @Transactional
    public MessageDto processMessageDto(MessageDto messageDto) {
        UUID chatId = messageDto.getChatId();
        UUID tempChatId = messageDto.getTempChatId();
        UUID senderId = messageDto.getSenderId();
        UUID recipientId = messageDto.getRecipientId();
        String text = messageDto.getText();

        log.info("🔍 ПРИНЯТО СООБЩЕНИЕ: chatId={}, tempChatId={}, senderId={}, recipientId={}",
                chatId, tempChatId, senderId, recipientId);

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("Sender not found"));
        User recipient = userRepository.findById(recipientId)
                .orElseThrow(() -> new RuntimeException("Recipient not found"));

        Chat chat = null;
        TemporaryChat tempChat = null;
        UUID finalChatId;
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
            chat = findOrCreateChat(sender, recipient, text, messageDto.getMedia());
            if (chat != null) {
                finalChatId = chat.getChatId();
            } else {
                tempChat = findOrCreateTemporaryChat(sender, recipient);
                finalChatId = tempChat.getTempChatId();
                isTemporary = true;
            }
        }

        Message message = createMessage(sender, recipient, messageDto, chat, tempChat);
        message = messageRepository.save(message);

        if (messageDto.getMedia() != null && !messageDto.getMedia().isEmpty()) {
            saveMessageMedia(message, messageDto.getMedia());
        }

        if (chat != null) {
            updateLastMessageInChat(chat, message);
        }

        MessageDto responseDto = createResponseDto(message, finalChatId, isTemporary);

        messagingTemplate.convertAndSendToUser(
                recipient.getUsername(),
                "/queue/messages",
                responseDto);

        try {
            String notificationMessage = generateNotificationMessage(messageDto);
            String senderName = generateSenderName(sender);
            internalNotificationService.sendNewMessageNotification(
                    recipientId,
                    senderId,
                    senderName,
                    notificationMessage);
            log.info("Push-уведомление отправлено пользователю {} от {}", recipient.getUsername(),
                    sender.getUsername());
        } catch (Exception e) {
            log.error("Ошибка при отправке push-уведомления пользователю {}: {}", recipient.getUsername(),
                    e.getMessage());
        }

        if (chat != null) {
            permanentChatUpdateService.notifyNewMessageInPermanentChat(
                    chat.getChatId(),
                    sender.getId(),
                    recipient.getId());
        }

        log.info("Отправлено сообщение пользователю {}: тип {}, текст {}, медиафайлов {}",
                recipient.getUsername(), responseDto.getContentType(),
                responseDto.getText() != null ? responseDto.getText() : "нет",
                responseDto.getMedia() != null ? responseDto.getMedia().size() : 0);

        return responseDto;
    }

    private String generateNotificationMessage(MessageDto messageDto) {
        if (messageDto.getMedia() != null && !messageDto.getMedia().isEmpty()) {

            MessageMediaDto firstMedia = messageDto.getMedia().get(0);
            if (firstMedia.getStickerId() != null) {
                return "Отправил(а) стикер";
            } else if ("image".equals(firstMedia.getContentType())) {
                return messageDto.getMedia().size() > 1 ? "Отправил(а) " + messageDto.getMedia().size() + " фото"
                        : "Отправил(а) фото";
            } else if ("video".equals(firstMedia.getContentType())) {
                return messageDto.getMedia().size() > 1 ? "Отправил(а) " + messageDto.getMedia().size() + " видео"
                        : "Отправил(а) видео";
            } else if ("file".equals(firstMedia.getContentType())) {
                return messageDto.getMedia().size() > 1 ? "Отправил(а) " + messageDto.getMedia().size() + " файлов"
                        : "Отправил(а) файл";
            }
        }

        return messageDto.getText() != null && !messageDto.getText().isEmpty() ? messageDto.getText()
                : "Новое сообщение";
    }

    private String generateSenderName(User sender) {
        if (sender.getFirstname() != null && sender.getSubname() != null) {
            return sender.getFirstname() + " " + sender.getSubname();
        } else if (sender.getFirstname() != null) {
            return sender.getFirstname();
        } else {
            return sender.getUsername();
        }
    }

    private void updateLastMessageInChat(Chat chat, Message message) {
        String lastMessagePreview = generateLastMessagePreview(message.getText(),
                message.getMedia() != null ? message.getMedia().stream()
                        .map(this::convertMediaToPreviewDto)
                        .collect(Collectors.toList())
                        : null);

        chat.setLastMessage(lastMessagePreview);
        chat.setLastMessageAt(message.getCreatedAt());
        chatRepository.save(chat);

        log.info("Обновлено последнее сообщение в чате {}: {}", chat.getChatId(), lastMessagePreview);
    }

    private MessageMediaDto convertMediaToPreviewDto(MessageMedia media) {
        MessageMediaDto dto = new MessageMediaDto();
        if (media.getContentType() != null) {
            dto.setContentType(media.getContentType().getTypeName());
        }
        if (media.getSticker() != null) {
            dto.setStickerId(media.getSticker().getId());
        }
        return dto;
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
        log.info("🔍 MESSAGE_PROCESSING_SERVICE: DETERMINE_CONTENT_TYPE: media contentType={}, mimeType={}",
                mediaDto.getContentType(), mediaDto.getMimeType());

        if (mediaDto.getStickerId() != null) {
            return contentTypeRepository.findByTypeName("sticker")
                    .orElseThrow(() -> new RuntimeException("Sticker content type not found"));
        } else if (mediaDto.getMediaUrl() != null) {
            String mimeType = mediaDto.getMimeType();
            if (mimeType != null) {
                if ("image".equals(mimeType) || mimeType.startsWith("image/")) {
                    log.info("🔍 MESSAGE_PROCESSING_SERVICE: Определен тип IMAGE для mimeType: {}", mimeType);
                    return contentTypeRepository.findByTypeName("image")
                            .orElseThrow(() -> new RuntimeException("Image content type not found"));
                } else if ("video".equals(mimeType) || mimeType.startsWith("video/")) {
                    log.info("🔍 MESSAGE_PROCESSING_SERVICE: Определен тип VIDEO для mimeType: {}", mimeType);
                    return contentTypeRepository.findByTypeName("video")
                            .orElseThrow(() -> new RuntimeException("Video content type not found"));
                } else {
                    log.info("🔍 MESSAGE_PROCESSING_SERVICE: Определен тип FILE для mimeType: {}", mimeType);
                    return contentTypeRepository.findByTypeName("file")
                            .orElseThrow(() -> new RuntimeException("File content type not found"));
                }
            }
        }

        log.info("🔍 MESSAGE_PROCESSING_SERVICE: Тип по умолчанию: FILE");
        return contentTypeRepository.findByTypeName("file")
                .orElseThrow(() -> new RuntimeException("Default file content type not found"));
    }

    private Chat findOrCreateChat(User sender, User recipient, String text, List<MessageMediaDto> media) {
        UUID senderId = sender.getId();
        UUID recipientId = recipient.getId();

        Optional<Chat> existingChat = chatRepository.findByUser1IdAndUser2Id(senderId, recipientId)
                .or(() -> chatRepository.findByUser1IdAndUser2Id(recipientId, senderId));

        if (existingChat.isPresent()) {
            Chat chat = existingChat.get();
            chat.setLastMessage(generateLastMessagePreview(text, media));
            chatRepository.save(chat);
            return chat;
        }
        return null;
    }

    private Message createMessage(User sender, User recipient, MessageDto messageDto,
            Chat chat, TemporaryChat tempChat) {
        Message message = new Message();
        message.setSender(sender);
        message.setRecipient(recipient);
        message.setText(messageDto.getText());
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
        log.info(
                "🔍 MESSAGE_PROCESSING_SERVICE: DETERMINE_MESSAGE_CONTENT_TYPE: message contentType={}, media count={}",
                messageDto.getContentType(),
                messageDto.getMedia() != null ? messageDto.getMedia().size() : 0);

        if (messageDto.getContentType() != null && !messageDto.getContentType().equals("text")) {
            String contentType = messageDto.getContentType().toLowerCase();
            log.info("🔍 MESSAGE_PROCESSING_SERVICE: Используем явный тип сообщения: {}", contentType);

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
            log.info("🔍 MESSAGE_PROCESSING_SERVICE: Тип сообщения определен по первому медиа: {}",
                    mediaContentType != null ? mediaContentType.getTypeName() : "null");
            return mediaContentType;
        }

        log.info("🔍 MESSAGE_PROCESSING_SERVICE: Тип сообщения по умолчанию: text");
        return contentTypeRepository.findByTypeName("text")
                .orElseThrow(() -> new RuntimeException("Default text content type not found"));
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
        }

        if (message.getMedia() != null && !message.getMedia().isEmpty()) {
            dto.setMedia(message.getMedia().stream()
                    .map(this::convertMediaToDto)
                    .collect(Collectors.toList()));
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

    @Transactional
    public void markMessagesAsRead(List<UUID> messageIds, UUID userId) {
        List<Message> messages = messageRepository.findAllById(messageIds);

        UUID chatId = null;

        messages.stream()
                .filter(msg -> msg.getRecipient().getId().equals(userId))
                .forEach(msg -> {
                    if (!msg.isRead()) {
                        msg.setRead(true);
                        messageRepository.save(msg);
                    }
                });

        if (!messages.isEmpty() && messages.get(0).getChat() != null) {
            chatId = messages.get(0).getChat().getChatId();
        }

        if (chatId != null) {
            permanentChatUpdateService.notifyMessagesRead(chatId, userId);
        }

        log.info("Marked {} messages as read for user {}", messages.size(), userId);
    }

    private TemporaryChat findOrCreateTemporaryChat(User sender, User recipient) {
        UUID senderId = sender.getId();
        UUID recipientId = recipient.getId();
        List<TemporaryChat> tempChats = temporaryChatRepository.findBySenderIdOrRecipientId(senderId, recipientId);

        for (TemporaryChat tchat : tempChats) {
            if ((tchat.getSender().getId().equals(senderId) && tchat.getRecipient().getId().equals(recipientId)) ||
                    (tchat.getSender().getId().equals(recipientId) && tchat.getRecipient().getId().equals(senderId))) {
                return tchat;
            }
        }

        TemporaryChat tempChat = new TemporaryChat();
        tempChat.setSender(sender);
        tempChat.setRecipient(recipient);
        tempChat.setCreatedAt(LocalDateTime.now());
        tempChat.setDurationMinutes(5);
        tempChat.setIsFinished(false);
        tempChat.setBothAgreed(false);
        return temporaryChatRepository.save(tempChat);
    }

    private String generateLastMessagePreview(String text, List<MessageMediaDto> media) {
        if (media != null && !media.isEmpty()) {
            if (media.stream().anyMatch(m -> m.getStickerId() != null)) {
                return "Стикер";
            } else if (media.stream().anyMatch(m -> "image".equals(m.getContentType()))) {
                return media.size() > 1 ? "Фотографии (" + media.size() + ")" : "Фото";
            } else if (media.stream().anyMatch(m -> "video".equals(m.getContentType()))) {
                return media.size() > 1 ? "Видео (" + media.size() + ")" : "Видео";
            } else if (media.stream().anyMatch(m -> "file".equals(m.getContentType()))) {
                return media.size() > 1 ? "Файлы (" + media.size() + ")" : "Файл";
            }
        }
        return text != null && text.length() > 50 ? text.substring(0, 47) + "..." : text;
    }
}