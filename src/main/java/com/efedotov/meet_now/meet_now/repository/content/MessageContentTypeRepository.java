package com.efedotov.meet_now.meet_now.repository.content;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.efedotov.meet_now.meet_now.model.content.MessageContentType;

public interface MessageContentTypeRepository extends JpaRepository<MessageContentType, UUID> {
    Optional<MessageContentType> findByTypeName(String typeName);
}