package com.efedotov.meet_now.meet_now.repository.app;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.efedotov.meet_now.meet_now.model.app.Document;

public interface DocumentRepository extends JpaRepository<Document, UUID> {
    Optional<Document> findByType(String type);
}
