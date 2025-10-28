package com.efedotov.meet_now.meet_now.dto.response.chat;

import java.util.UUID;

import com.efedotov.meet_now.meet_now.dto.response.content.StickerDto;

import lombok.Data;

@Data
public class MessageMediaDto {
    private UUID id;
    private String contentType = "file";
    private String mediaUrl;
    private Long fileSize;
    private String mimeType;
    private String thumbnailUrl;
    private UUID stickerId;
    private StickerDto sticker;
    private Integer sortOrder = 0;
}