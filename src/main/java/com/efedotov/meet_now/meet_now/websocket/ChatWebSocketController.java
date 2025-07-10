package com.efedotov.meet_now.meet_now.websocket;

import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.service.WebSocketMessageService;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class ChatWebSocketController {

    private final WebSocketMessageService messageService;

    public ChatWebSocketController(WebSocketMessageService messageService) {
        this.messageService = messageService;
    }

    @MessageMapping("/chat.sendMessage")
    @SendTo("/topic/public")
    public Message sendMessage(@Payload Message message) {
        return messageService.processMessage(message);
    }
}