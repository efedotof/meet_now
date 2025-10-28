package com.efedotov.meet_now.meet_now.controller.chat;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.internal.UpdateConstraintRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.AgreeChatRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.CreateTemporaryChatRequest;
import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.model.chat.Chat;
import com.efedotov.meet_now.meet_now.model.chat.ChatConstraint;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/chat")
@Tag(name = "Chat", description = "Управление чатами: создание временного чата, завершение чата, получение списка активных чатов, история сообщений")
@RequiredArgsConstructor
@EnableMethodSecurity
public class ChatController {

    private final ChatService chatService;

    @Operation(summary = "Создать временный чат")
    @PostMapping("/temporary")
    public ResponseEntity<TemporaryChat> createTemporaryChat(CreateTemporaryChatRequest request) {
        var sender = new User();
        sender.setId(request.getSenderId());
        var recipient = new User();
        recipient.setId(request.getRecipientId());

        TemporaryChat tempChat = chatService.createTemporaryChat(sender, recipient, request.getDurationMinutes());
        return ResponseEntity.ok(tempChat);
    }

    @Operation(summary = "Завершить временный чат")
    @PostMapping("/temporary/{tempChatId}/finish")
    public ResponseEntity<Void> finishTemporaryChat(@PathVariable UUID tempChatId) {
        chatService.finishTemporaryChat(tempChatId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Пользователь соглашается продолжить чат")
    @PostMapping("/temporary/{tempChatId}/agree")
    public ResponseEntity<Void> agreeToContinue(
            AgreeChatRequest request) {
        chatService.agreeToContinue(request.getTempChatId(), request.getUserId());
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить активные временные чаты пользователя")
    @GetMapping("/temporary/active")
    public ResponseEntity<List<TemporaryChatDto>> getActiveTemporaryChats(@RequestParam UUID userId) {
        List<TemporaryChatDto> chatDtos = chatService.getActiveTemporaryChatsForUser(userId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());

        return ResponseEntity.ok(chatDtos);
    }

    @Operation(summary = "Получить постоянные чаты пользователя")
    @GetMapping("/permanent")
    public ResponseEntity<List<PermanentChatResponseDto>> getPermanentChats(@RequestParam UUID userId) {
        List<PermanentChatResponseDto> chatDtos = chatService.getPermanentChatsForUser(userId).stream()
                .map(this::mapToPermanentChatDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(chatDtos);
    }

    private PermanentChatResponseDto mapToPermanentChatDto(Chat chat) {
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
    
    @Operation(summary = "Получить ограничения временного чата")
    @GetMapping("/temporary/{tempChatId}/constraint")
    public ResponseEntity<ChatConstraint> getChatConstraint(@PathVariable UUID tempChatId) {
        return chatService.getChatConstraint(tempChatId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @Operation(summary = "Обновить ограничения временного чата")
    @PutMapping("/temporary/{tempChatId}/constraint")
    public ResponseEntity<Void> updateChatConstraint(
            UpdateConstraintRequest request) {
        chatService.updateChatConstraint(request.getTempChatId(), request.isCanStart(), request.getWaitSeconds());
        return ResponseEntity.ok().build();
    }

    private TemporaryChatDto mapToDto(TemporaryChat chat) {
        return TemporaryChatDto.builder()
                .tempChatId(chat.getTempChatId())
                .senderId(chat.getSender().getId())
                .recipientId(chat.getRecipient().getId())
                .createdAt(chat.getCreatedAt())
                .durationMinutes(chat.getDurationMinutes())
                .isFinished(chat.getIsFinished())
                .bothAgreed(chat.getBothAgreed())
                .build();
    }

}