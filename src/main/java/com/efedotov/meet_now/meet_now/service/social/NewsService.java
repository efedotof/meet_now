package com.efedotov.meet_now.meet_now.service.social;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.request.social.NewsRequest;
import com.efedotov.meet_now.meet_now.dto.response.social.NewsResponse;
import com.efedotov.meet_now.meet_now.model.app.News;
import com.efedotov.meet_now.meet_now.repository.app.NewsRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class NewsService {

    private final NewsRepository newsRepository;

    public List<NewsResponse> getAll() {
        return newsRepository.findAll()
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public List<NewsResponse> getActive() {
        return newsRepository.findAllByIsActiveTrueOrderBySortOrderAsc()
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public NewsResponse getById(Long id) {
        News news = newsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Новость с id " + id + " не найдена"));
        return toResponse(news);
    }

    public NewsResponse create(NewsRequest request) {
        News news = News.builder()
                .imageUrl(request.getImageUrl())
                .actionUrl(request.getActionUrl())
                .title(request.getTitle())
                .description(request.getDescription())
                .sortOrder(request.getSortOrder())
                .isActive(request.getIsActive())
                .build();
        return toResponse(newsRepository.save(news));
    }

    public NewsResponse update(Long id, NewsRequest request) {
        News news = newsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Новость с id " + id + " не найдена"));
        news.setImageUrl(request.getImageUrl());
        news.setActionUrl(request.getActionUrl());
        news.setTitle(request.getTitle());
        news.setDescription(request.getDescription());
        news.setSortOrder(request.getSortOrder());
        news.setIsActive(request.getIsActive());
        return toResponse(newsRepository.save(news));
    }

    public void delete(Long id) {
        if (!newsRepository.existsById(id)) {
            throw new RuntimeException("Новость с id " + id + " не найдена");
        }
        newsRepository.deleteById(id);
    }

    private NewsResponse toResponse(News news) {
        return NewsResponse.builder()
                .id(news.getId())
                .imageUrl(news.getImageUrl())
                .actionUrl(news.getActionUrl())
                .title(news.getTitle())
                .description(news.getDescription())
                .sortOrder(news.getSortOrder())
                .isActive(news.getIsActive())
                .createdAt(news.getCreatedAt())
                .updatedAt(news.getUpdatedAt())
                .build();
    }
}
