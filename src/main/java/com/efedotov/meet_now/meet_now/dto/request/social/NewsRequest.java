package com.efedotov.meet_now.meet_now.dto.request.social;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class NewsRequest {

    @NotBlank(message = "Ссылка на изображение обязательна")
    @Size(max = 512)
    private String imageUrl;

    @Size(max = 512)
    private String actionUrl;

    @Size(max = 255)
    private String title;

    private String description;

    private Integer sortOrder = 0;

    private Boolean isActive = true;
}
