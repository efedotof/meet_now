package com.efedotov.meet_now.meet_now.websocket;

import java.security.Principal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import com.efedotov.meet_now.meet_now.dto.MessageDto;
import com.efedotov.meet_now.meet_now.dto.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.dto.UserActivityDto;
import com.efedotov.meet_now.meet_now.dto.request.ChatMessagesRequest;
import com.efedotov.meet_now.meet_now.dto.request.MarkMessagesReadRequest;
import com.efedotov.meet_now.meet_now.model.Chat;
import com.efedotov.meet_now.meet_now.model.TemporaryChat;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.chat.ActivityNotificationService;
import com.efedotov.meet_now.meet_now.service.chat.ChatQueryService;
import com.efedotov.meet_now.meet_now.service.chat.MessageProcessingService;
import com.efedotov.meet_now.meet_now.service.chat.MessageQueryService;

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
                .map(this::mapToDto)
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
        List<Chat> chats = chatQueryService.getPermanentChats(userId);
        log.info("Returning {} permanent chats to username={}", chats.size(), username);

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.permanent",
                chats);
    }

    @MessageMapping("/chat.activity")
    public void handleUserActivity(@Payload UserActivityDto activityDto, Principal principal) {
        activityNotificationService.sendActivityNotification(activityDto);
    }

    private TemporaryChatDto mapToDto(TemporaryChat chat) {
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
}