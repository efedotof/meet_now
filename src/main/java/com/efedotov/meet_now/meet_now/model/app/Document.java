package com.efedotov.meet_now.meet_now.model.app;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "documents")
public class Document {
    @Id
    @GeneratedValue
    private UUID id;
    private String type;
    private String content;
    private String version;
    private LocalDateTime createdAt;
}
