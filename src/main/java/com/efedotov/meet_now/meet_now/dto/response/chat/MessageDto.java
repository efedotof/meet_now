package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.efedotov.meet_now.meet_now.dto.response.gift.GiftDto;

import lombok.Data;

@Data
public class MessageDto {
    private UUID id;
    private UUID chatId;
    private UUID tempChatId;
    private UUID senderId;
    private UUID recipientId;
    private String text;
    private LocalDateTime createdAt;
    private boolean read;
    private String contentType = "text";
    private UUID giftId;
    private GiftDto gift;
    private List<MessageMediaDto> media = new ArrayList<>();
}
