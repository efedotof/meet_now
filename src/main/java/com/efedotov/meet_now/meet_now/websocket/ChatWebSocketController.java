package com.efedotov.meet_now.meet_now.websocket;

import java.security.Principal;
import java.util.UUID;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;

import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.service.WebSocketMessageService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatWebSocketController {

    private final WebSocketMessageService messageService;

    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload Message message) {
        messageService.processMessage(message);
    }

    @MessageMapping("/chat.getMessages")
    public void getChatMessages(@Payload UUID chatId, Principal principal) {
        if (principal != null) {
            messageService.sendMessagesForChatToUser(chatId, principal.getName());
        }
    }
}
