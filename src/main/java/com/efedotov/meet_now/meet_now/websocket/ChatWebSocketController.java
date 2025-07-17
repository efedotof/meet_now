package com.efedotov.meet_now.meet_now.websocket;

import com.efedotov.meet_now.meet_now.dto.MessageDto;
import com.efedotov.meet_now.meet_now.dto.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.dto.request.ChatMessagesRequest;
import com.efedotov.meet_now.meet_now.model.Chat;
import com.efedotov.meet_now.meet_now.model.TemporaryChat;
import com.efedotov.meet_now.meet_now.service.WebSocketMessageService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatWebSocketController {

    private final WebSocketMessageService messageService;
    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload MessageDto messageDto) {
        log.info("Received sendMessage request from userId={} to chatId={}, message={}",
                 messageDto.getSenderId(), messageDto.getChatId(), messageDto.getText());
        messageService.processMessageDto(messageDto);
        log.info("Processed sendMessage for chatId={}", messageDto.getChatId());
    }

    @MessageMapping("/chat.getMessages")
    public void getChatMessages(@Payload ChatMessagesRequest request) {
        log.info("Received getMessages request: chatId={}, userId={}", request.getChatId(), request.getUserId());
        messageService.sendMessagesForChatToUser(request.getChatId(), request.getUserId().toString());
        log.info("Sent messages for chatId={} to userId={}", request.getChatId(), request.getUserId());
    }

    @MessageMapping("/chat.getActiveTemporary")
    public void getActiveTemporaryChats(@Payload UUID userId) {
        log.info("Received getActiveTemporary request from userId={}", userId);
        List<TemporaryChatDto> chats = messageService.getActiveTemporaryChats(userId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
        log.info("Returning {} active temporary chats to userId={}", chats.size(), userId);
        messagingTemplate.convertAndSendToUser(userId.toString(), "/queue/chat.temporary.active", chats);
    }

    @MessageMapping("/chat.getPermanent")
    public void getPermanentChats(@Payload UUID userId) {
        log.info("Received getPermanent request from userId={}", userId);
        List<Chat> chats = messageService.getPermanentChats(userId);
        log.info("Returning {} permanent chats to userId={}", chats.size(), userId);
        messagingTemplate.convertAndSendToUser(userId.toString(), "/queue/chat.permanent", chats);
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

    
}
