package com.efedotov.meet_now.meet_now.controller.chat;

import com.efedotov.meet_now.meet_now.model.Chat;
import com.efedotov.meet_now.meet_now.model.TemporaryChat;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.model.ChatConstraint;
import com.efedotov.meet_now.meet_now.service.ChatService;
import com.efedotov.meet_now.meet_now.model.ChatGame;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/chat")
@Tag(name = "Chat", description = "Управление чатами: создание временного чата, завершение чата, получение списка активных чатов, история сообщений")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;


    @Operation(summary = "Создать временный чат")
    @PostMapping("/temporary")
    public ResponseEntity<TemporaryChat> createTemporaryChat(
            @RequestParam UUID senderId,
            @RequestParam UUID recipientId,
            @RequestParam(defaultValue = "10") int durationMinutes) {
        
        var sender = new User();
        sender.setId(senderId);
        var recipient = new User();
        recipient.setId(recipientId);

        TemporaryChat tempChat = chatService.createTemporaryChat(sender, recipient, durationMinutes);
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
            @PathVariable UUID tempChatId,
            @RequestParam UUID userId) {
        chatService.agreeToContinue(tempChatId, userId);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить активные временные чаты пользователя")
    @GetMapping("/temporary/active")
    public ResponseEntity<List<TemporaryChat>> getActiveTemporaryChats(@RequestParam UUID userId) {
        List<TemporaryChat> chats = chatService.getActiveTemporaryChatsForUser(userId);
        return ResponseEntity.ok(chats);
    }

    @Operation(summary = "Получить постоянные чаты пользователя")
    @GetMapping("/permanent")
    public ResponseEntity<List<Chat>> getPermanentChats(@RequestParam UUID userId) {
        List<Chat> chats = chatService.getPermanentChatsForUser(userId);
        return ResponseEntity.ok(chats);
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
            @PathVariable UUID tempChatId,
            @RequestParam boolean canStart,
            @RequestParam int waitSeconds) {
        chatService.updateChatConstraint(tempChatId, canStart, waitSeconds);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получить игры чата")
    @GetMapping("/{chatId}/games")
    public ResponseEntity<List<ChatGame>> getChatGames(@PathVariable UUID chatId) {
        List<ChatGame> games = chatService.getChatGames(chatId);
        return ResponseEntity.ok(games);
    }

    @Operation(summary = "Добавить игру в чат")
    @PostMapping("/{chatId}/games")
    public ResponseEntity<ChatGame> addGameToChat(
            @PathVariable UUID chatId,
            @RequestParam String gameType,
            @RequestParam String initialState) {
        ChatGame game = chatService.addGameToChat(chatId, gameType, initialState);
        return ResponseEntity.ok(game);
    }

}
