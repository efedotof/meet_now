package com.efedotov.meet_now.meet_now.model.chat;

import com.efedotov.meet_now.meet_now.model.content.MessageContentType;
import com.efedotov.meet_now.meet_now.model.content.Sticker;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Entity
@Table(name = "message_media")
public class MessageMedia {
    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "message_id")
    private Message message;

    @ManyToOne
    @JoinColumn(name = "content_type")
    private MessageContentType contentType;

    @Column(name = "media_url")
    private String mediaUrl;

    @Column(name = "file_size")
    private Long fileSize;

    @Column(name = "mime_type")
    private String mimeType;

    @Column(name = "thumbnail_url")
    private String thumbnailUrl;

    @ManyToOne
    @JoinColumn(name = "sticker_id")
    private Sticker sticker;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}