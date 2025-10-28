package com.efedotov.meet_now.meet_now.model.content;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "message_content_types")
public class MessageContentType {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "type_name", unique = true, nullable = false, length = 50)
    private String typeName;
}