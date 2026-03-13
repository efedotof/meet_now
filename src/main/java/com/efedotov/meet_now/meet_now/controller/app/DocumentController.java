package com.efedotov.meet_now.meet_now.controller.app;

import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.service.app.DocumentService;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/document")
@Tag(name = "Document", description = "Получить документы.")
@RequiredArgsConstructor
@EnableMethodSecurity
public class DocumentController {

    private final DocumentService service;

    @GetMapping("/{type}")
    public ResponseEntity<String> getDocument(@PathVariable String type) {
        String content = service.getDocumentByType(type);
        return ResponseEntity.ok(content);
    }

}
