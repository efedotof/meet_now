package com.efedotov.meet_now.meet_now.dto.response.search;

import com.efedotov.meet_now.meet_now.dto.response.chat.TemporaryChatDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchResponseDto {
    private String message;
    private TemporaryChatDto temporaryChat;
    private Boolean success;
}