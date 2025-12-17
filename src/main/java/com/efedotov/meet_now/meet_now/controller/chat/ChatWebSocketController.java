package com.efedotov.meet_now.meet_now.controller.chat;

import java.security.Principal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.messaging.MessagingException;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import com.efedotov.meet_now.meet_now.dto.request.chat.AgreeChatWebSocketRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.ChatMessagesRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.MarkMessagesReadRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.PaginatedMessagesRequest;
import com.efedotov.meet_now.meet_now.dto.response.chat.AgreeChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.MessageDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.PaginatedMessagesResponse;
import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserActivityDto;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.chat.ActivityNotificationService;
import com.efedotov.meet_now.meet_now.service.chat.ChatQueryService;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;
import com.efedotov.meet_now.meet_now.service.chat.MessageProcessingService;
import com.efedotov.meet_now.meet_now.service.chat.MessageQueryService;
import com.efedotov.meet_now.meet_now.service.chat.PermanentChatUpdateService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatWebSocketController {

    private final MessageProcessingService messageProcessingService;
    private final MessageQueryService messageQueryService;
    private final ChatQueryService chatQueryService;
    private final ActivityNotificationService activityNotificationService;
    private final SimpMessagingTemplate messagingTemplate;
    private final PermanentChatUpdateService permanentChatUpdateService;
    private final ChatService chatService;

    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload MessageDto messageDto, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();

        UUID senderId = userDetails.getUserId();
        messageDto.setSenderId(senderId);

        log.info("Received sendMessage request from userId={} to chatId={}, message={}",
                senderId, messageDto.getChatId(), messageDto.getText());
        messageProcessingService.processMessageDto(messageDto);
        log.info("Processed sendMessage for chatId={}", messageDto.getChatId());
    }
    
    @MessageMapping("/chat.getMessages")
    public void getChatMessages(@Payload ChatMessagesRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getMessages request: chatId={}, userId={}, username={}",
                request.getChatId(), userId, username);

        messageQueryService.sendMessagesForChatToUser(request.getChatId(), username);
        log.info("Sent messages for chatId={} to username={}", request.getChatId(), username);
    }

    @MessageMapping("/chat.getActiveTemporary")
    public void getActiveTemporaryChats(Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getActiveTemporary request from userId={}", userId);
        List<TemporaryChatDto> chats = chatQueryService.getActiveTemporaryChats(userId).stream()
                .map(this::mapTemporaryToDto)
                .collect(Collectors.toList());
        log.info("Returning {} active temporary chats to username={}", chats.size(), username);
        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.temporary.active",
                chats);
    }

    @MessageMapping("/chat.getPermanent")
    public void getPermanentChats(Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getPermanent request from userId={}", userId);

        List<PermanentChatResponseDto> chatDtos = chatQueryService.getPermanentChatsAsDto(userId);
        log.info("Returning {} permanent chats to username={}", chatDtos.size(), username);

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.permanent",
                chatDtos);
    }

    @MessageMapping("/chat.activity")
    public void handleUserActivity(@Payload UserActivityDto activityDto, Principal principal) {
        activityNotificationService.sendActivityNotification(activityDto);
    }

    private TemporaryChatDto mapTemporaryToDto(TemporaryChat chat) {
        TemporaryChatDto dto = new TemporaryChatDto();
        dto.setTempChatId(chat.getTempChatId());
        dto.setSenderId(chat.getSender().getId());
        dto.setRecipientId(chat.getRecipient().getId());
        dto.setCreatedAt(chat.getCreatedAt());
        dto.setDurationMinutes(chat.getDurationMinutes());
        dto.setIsFinished(chat.getIsFinished());
        dto.setBothAgreed(chat.getBothAgreed());
        return dto;
    }

    @MessageMapping("/chat.getMessages.paginated")
    public void getPaginatedMessages(@Payload PaginatedMessagesRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getPaginatedMessages request: chatId={}, page={}, size={}, userId={}",
                request.getChatId(), request.getPage(), request.getSize(), userId);

        PaginatedMessagesResponse response = messageQueryService.getPaginatedMessagesForChat(
                request.getChatId(), request.getPage(), request.getSize());

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.messages.paginated",
                response);

        log.info("Sent paginated messages for chatId={}, page={} to username={}",
                request.getChatId(), request.getPage(), username);
    }

    @MessageMapping("/chat.markAsRead")
    public void markMessagesAsRead(
            @Payload MarkMessagesReadRequest request,
            Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();

        log.info("Marking messages as read by user: {}, message IDs: {}",
                userId, request.getMessageIds());

        messageProcessingService.markMessagesAsRead(request.getMessageIds(), userId);
    }

    @MessageMapping("/chat.subscribeNewTemporary")
    public void subscribeToNewTemporaryChats(Principal principal) {
        String username = principal.getName();
        log.info("Пользователь {} подписался на получение новых временных чатов", username);
    }

    @MessageMapping("/chat.subscribePermanent")
    public void subscribeToPermanentChats(Principal principal) {
        String username = principal.getName();
        log.info("Пользователь {} подписался на получение обновлений постоянных чатов", username);

        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();

        permanentChatUpdateService.sendUpdatedPermanentChats(userId);
    }

    @MessageMapping("/chat.agreeToContinue")
    public void agreeToContinue(@Payload AgreeChatWebSocketRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID authenticatedUserId = userDetails.getUserId();

        if (!authenticatedUserId.equals(request.getUserId())) {
            log.warn("Пользователь {} пытается согласиться от имени {}", authenticatedUserId, request.getUserId());
            return;
        }

        log.info("Получено согласие на продолжение чата: tempChatId={}, userId={}",
                request.getTempChatId(), request.getUserId());

        try {
            chatService.agreeToContinue(request.getTempChatId(), request.getUserId());

            TemporaryChat updatedChat = chatService.getTemporaryChatById(request.getTempChatId())
                    .orElseThrow(() -> new RuntimeException("Чат не найден"));

            AgreeChatResponseDto response = new AgreeChatResponseDto();
            response.setTempChatId(request.getTempChatId());
            response.setUserId(request.getUserId());
            response.setBothAgreed(updatedChat.getBothAgreed());
            response.setSuccess(true);

            messagingTemplate.convertAndSendToUser(
                    userDetails.getUsername(),
                    "/queue/chat.agree.response",
                    response);

            UUID otherUserId = getOtherUserId(updatedChat, request.getUserId());
            String otherUserUsername = getUsernameById(otherUserId);

            if (otherUserUsername != null) {
                messagingTemplate.convertAndSendToUser(
                        otherUserUsername,
                        "/queue/chat.agree.notification",
                        response);
            }

            if (Boolean.TRUE.equals(updatedChat.getBothAgreed())) {
                handleBothAgreed(updatedChat);
            }

            log.info("Согласие на продолжение чата обработано успешно: tempChatId={}", request.getTempChatId());

        } catch (MessagingException e) {
            log.error("Ошибка при обработке согласия на продолжение чата: {}", e.getMessage());

            AgreeChatResponseDto errorResponse = new AgreeChatResponseDto();
            errorResponse.setTempChatId(request.getTempChatId());
            errorResponse.setUserId(request.getUserId());
            errorResponse.setSuccess(false);
            errorResponse.setErrorMessage(e.getMessage());

            messagingTemplate.convertAndSendToUser(
                    userDetails.getUsername(),
                    "/queue/chat.agree.response",
                    errorResponse);
        }
    }

    private UUID getOtherUserId(TemporaryChat chat, UUID currentUserId) {
        if (chat.getSender().getId().equals(currentUserId)) {
            return chat.getRecipient().getId();
        } else {
            return chat.getSender().getId();
        }
    }

    private String getUsernameById(UUID userId) {
        try {
            return chatService.getUserById(userId)
                    .map(user -> user.getUsername())
                    .orElse(null);
        } catch (Exception e) {
            log.error("Ошибка при получении username для userId={}: {}", userId, e.getMessage());
            return null;
        }
    }

    private void handleBothAgreed(TemporaryChat tempChat) {
        log.info("Оба пользователя согласились продолжить чат: {}", tempChat.getTempChatId());

        chatService.createPermanentChatFromTemporary(tempChat);

        UUID user1Id = tempChat.getSender().getId();
        UUID user2Id = tempChat.getRecipient().getId();

        List<PermanentChatResponseDto> user1Chats = chatQueryService.getPermanentChatsAsDto(user1Id);
        List<PermanentChatResponseDto> user2Chats = chatQueryService.getPermanentChatsAsDto(user2Id);

        PermanentChatResponseDto user1NewChat = findNewlyCreatedChat(user1Chats, user1Id, user2Id);
        PermanentChatResponseDto user2NewChat = findNewlyCreatedChat(user2Chats, user1Id, user2Id);

        String user1Username = tempChat.getSender().getUsername();
        String user2Username = tempChat.getRecipient().getUsername();

        if (user1NewChat != null) {
            messagingTemplate.convertAndSendToUser(
                    user1Username,
                    "/queue/chat.permanent.created",
                    user1NewChat);
            log.info("Отправлен PermanentChatResponseDto пользователю {}: chatId={}",
                    user1Username, user1NewChat.getChatId());
        }

        if (user2NewChat != null) {
            messagingTemplate.convertAndSendToUser(
                    user2Username,
                    "/queue/chat.permanent.created",
                    user2NewChat);
            log.info("Отправлен PermanentChatResponseDto пользователю {}: chatId={}",
                    user2Username, user2NewChat.getChatId());
        }

        permanentChatUpdateService.sendUpdatedPermanentChats(user1Id);
        permanentChatUpdateService.sendUpdatedPermanentChats(user2Id);

        log.info("Постоянный чат создан и пользователи уведомлены: {}", tempChat.getTempChatId());
    }

    private PermanentChatResponseDto findNewlyCreatedChat(List<PermanentChatResponseDto> chats,
            UUID user1Id, UUID user2Id) {
        return chats.stream()
                .filter(chat -> (chat.getUser1Id().equals(user1Id) && chat.getUser2Id().equals(user2Id)) ||
                        (chat.getUser1Id().equals(user2Id) && chat.getUser2Id().equals(user1Id)))
                .findFirst()
                .orElse(null);
    }
}