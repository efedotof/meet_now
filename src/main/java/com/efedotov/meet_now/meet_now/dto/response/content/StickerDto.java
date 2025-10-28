package com.efedotov.meet_now.meet_now.dto.response.content;

import java.util.UUID;

import lombok.Data;

@Data
public class StickerDto {
    private UUID id;
    private String emoji;
    private String imageUrl;
}