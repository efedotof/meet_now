package com.efedotov.meet_now.meet_now.service.app;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.exception.DocumentNotFoundException;
import com.efedotov.meet_now.meet_now.model.app.Document;
import com.efedotov.meet_now.meet_now.repository.app.DocumentRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class DocumentService {
    private final DocumentRepository documentRepository;

    public String getDocumentByType(String type) {
        return documentRepository.findByType(type)
                .map(Document::getContent)
                .orElseThrow(() -> new DocumentNotFoundException("Document not found: " + type));
    }

}
