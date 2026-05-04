package com.efedotov.meet_now.meet_now.controller.news;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.social.NewsRequest;
import com.efedotov.meet_now.meet_now.dto.response.social.NewsResponse;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.social.NewsService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/news")
@RequiredArgsConstructor
public class NewsController {

    private final NewsService newsService;

    @GetMapping
    @AdminOnly
    public ResponseEntity<List<NewsResponse>> getAll() {
        return ResponseEntity.ok(newsService.getAll());
    }

    @GetMapping("/active")
    public ResponseEntity<List<NewsResponse>> getActive() {
        return ResponseEntity.ok(newsService.getActive());
    }

    @GetMapping("/{id}")
    public ResponseEntity<NewsResponse> getById(@PathVariable Long id) {
        return ResponseEntity.ok(newsService.getById(id));
    }

    @PostMapping
    @AdminOnly
    public ResponseEntity<NewsResponse> create(@Valid @RequestBody NewsRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(newsService.create(request));
    }

    @PutMapping("/{id}")
    @AdminOnly
    public ResponseEntity<NewsResponse> update(@PathVariable Long id,
            @Valid @RequestBody NewsRequest request) {
        return ResponseEntity.ok(newsService.update(id, request));
    }

    @DeleteMapping("/{id}")
    @AdminOnly
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        newsService.delete(id);
        return ResponseEntity.noContent().build();
    }
}