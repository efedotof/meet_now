package com.efedotov.meet_now.meet_now.dto.response.content;

import java.util.List;
import java.util.UUID;

import lombok.Data;

@Data
public class StickerPackDto {
    private UUID id;
    private String title;
    private List<StickerDto> stickers;
}