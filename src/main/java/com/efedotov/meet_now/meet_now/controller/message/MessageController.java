package com.efedotov.meet_now.meet_now.controller.message;

import java.util.List;
import java.util.UUID;

import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.MessageDto;
import com.efedotov.meet_now.meet_now.model.Message;
import com.efedotov.meet_now.meet_now.service.MessageService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/message")
@RequiredArgsConstructor
@EnableMethodSecurity
public class MessageController {

    private final MessageService messageService;

    @GetMapping("/chat/{chatId}")
    public List<MessageDto> getMessagesByChatId(@PathVariable UUID chatId) {
        List<Message> messages = messageService.getMessagesByChatId(chatId);
        return messages.stream().map(this::toDto).toList();
    }

    private MessageDto toDto(Message message) {
        MessageDto dto = new MessageDto();
        dto.setId(message.getId());
        dto.setChatId(message.getChat().getChatId());
        dto.setSenderId(message.getSender().getId());
        dto.setRecipientId(message.getRecipient().getId());
        dto.setText(message.getText());
        dto.setCreatedAt(message.getCreatedAt());
        return dto;
    }
}
