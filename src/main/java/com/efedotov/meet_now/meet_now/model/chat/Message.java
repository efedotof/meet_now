package com.efedotov.meet_now.meet_now.model.chat;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.efedotov.meet_now.meet_now.model.content.MessageContentType;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "messages")
public class Message {
    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "chat_id")
    private Chat chat;

    @ManyToOne
    @JoinColumn(name = "sender_id")
    private User sender;

    @ManyToOne
    @JoinColumn(name = "recipient_id")
    private User recipient;

    @Column(columnDefinition = "TEXT")
    private String text;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @ManyToOne
    @JoinColumn(name = "temp_chat_id")
    private TemporaryChat temporaryChat;

    @Column(name = "is_read", columnDefinition = "boolean default false")
    @JsonProperty("isRead")
    private boolean isRead = false;

    @ManyToOne
    @JoinColumn(name = "content_type")
    private MessageContentType contentType;

    @OneToMany(mappedBy = "message", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC")
    private List<MessageMedia> media = new ArrayList<>();

    public void addMedia(MessageMedia mediaItem) {
        mediaItem.setMessage(this);
        this.media.add(mediaItem);
    }

    public void removeMedia(MessageMedia mediaItem) {
        mediaItem.setMessage(null);
        this.media.remove(mediaItem);
    }

    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @ManyToOne
    @JoinColumn(name = "deleted_by")
    private User deletedBy;
}