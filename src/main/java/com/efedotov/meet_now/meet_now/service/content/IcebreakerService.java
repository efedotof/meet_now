package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Random;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.request.icebreaker.IcebreakerCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.icebreaker.IcebreakerUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.content.IcebreakerStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.content.IcebreakerTopec;
import com.efedotov.meet_now.meet_now.repository.content.IcebreakerTopicRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class IcebreakerService {

    private final IcebreakerTopicRepository icebreakerTopecRepository;
    private final Random random = new Random();

    @AdminOnly
    public Page<IcebreakerTopec> getAllTopicsWithPagination(int page, int size, String search) {
        Pageable pageable = PageRequest.of(page, size);

        if (search != null && !search.trim().isEmpty()) {
            String safeText = escapeForLike(search.trim());
            return icebreakerTopecRepository.findByTextContainingIgnoreCase(safeText, pageable);
        }

        return icebreakerTopecRepository.findAll(pageable);
    }

    @AdminOnly
    public IcebreakerStatisticsResponse getIcebreakerStatistics() {
        long totalTopics = icebreakerTopecRepository.count();
        long topicsWithText = totalTopics;
        long topicsWithLongText = icebreakerTopecRepository.countByTextLengthGreaterThan(50);

        List<IcebreakerTopec> longestTopics = icebreakerTopecRepository.findTop5ByOrderByTextLengthDesc();

        return IcebreakerStatisticsResponse.builder()
                .totalTopics(totalTopics)
                .topicsWithText(topicsWithText)
                .topicsWithLongText(topicsWithLongText)
                .topicsWithShortText(totalTopics - topicsWithLongText)
                .longestTopics(longestTopics)
                .build();
    }

    @AdminOnly
    public IcebreakerTopec getTopicById(Long id) {
        return icebreakerTopecRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Тема с id " + id + " не найдена"));
    }

    @AdminOnly
    @Transactional
    public IcebreakerTopec createTopic(IcebreakerCreateRequest request) {
        if (icebreakerTopecRepository.existsByTextIgnoreCase(request.getText())) {
            throw new IllegalArgumentException("Тема с таким текстом уже существует");
        }

        IcebreakerTopec topic = new IcebreakerTopec();
        topic.setText(request.getText());

        IcebreakerTopec savedTopic = icebreakerTopecRepository.save(topic);
        log.info("Создана новая тема для общения: ID {}", savedTopic.getId());

        return savedTopic;
    }

    @AdminOnly
    @Transactional
    public IcebreakerTopec updateTopic(Long id, IcebreakerUpdateRequest request) {
        IcebreakerTopec topic = getTopicById(id);

        if (request.getText() != null &&
                !request.getText().equals(topic.getText()) &&
                icebreakerTopecRepository.existsByTextIgnoreCase(request.getText())) {
            throw new IllegalArgumentException("Тема с таким текстом уже существует");
        }

        if (request.getText() != null) {
            topic.setText(request.getText());
        }

        IcebreakerTopec updatedTopic = icebreakerTopecRepository.save(topic);
        log.info("Обновлена тема для общения: ID {}", id);

        return updatedTopic;
    }

    @AdminOnly
    @Transactional
    public void deleteTopic(Long id) {
        if (!icebreakerTopecRepository.existsById(id)) {
            throw new NoSuchElementException("Тема с id " + id + " не найдена");
        }
        icebreakerTopecRepository.deleteById(id);
        log.info("Удалена тема для общения: ID {}", id);
    }

    @AdminOnly
    @Transactional
    public void bulkDeleteTopics(List<Long> topicIds) {
        if (topicIds == null || topicIds.isEmpty()) {
            throw new IllegalArgumentException("Список ID тем не может быть пустым");
        }

        long deletedCount = 0;
        for (Long topicId : topicIds) {
            try {
                deleteTopic(topicId);
                deletedCount++;
            } catch (Exception e) {
                log.warn("Не удалось удалить тему с ID {}: {}", topicId, e.getMessage());
            }
        }

        log.info("Удалено {} тем из {}", deletedCount, topicIds.size());
    }

    @AdminOnly
    public List<IcebreakerTopec> exportAllTopics() {
        return icebreakerTopecRepository.findAll();
    }

    @AdminOnly
    public Page<IcebreakerTopec> searchTopicsWithPagination(String text, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        String safeText = escapeForLike(text);
        return icebreakerTopecRepository.findByTextContainingIgnoreCase(safeText, pageable);
    }

    public List<IcebreakerTopec> getAllTopics() {
        return icebreakerTopecRepository.findAll();
    }

    public IcebreakerTopec getRandomTopic() {
        List<IcebreakerTopec> allTopics = icebreakerTopecRepository.findAll();
        if (allTopics.isEmpty()) {
            throw new NoSuchElementException("Темы для общения не найдены");
        }
        int index = random.nextInt(allTopics.size());
        return allTopics.get(index);
    }

    @Transactional
    public IcebreakerTopec addTopic(String text) {
        IcebreakerTopec topic = new IcebreakerTopec();
        topic.setText(text);
        return icebreakerTopecRepository.save(topic);
    }

    @Transactional
    public IcebreakerTopec updateTopic(Long id, String newText) {
        IcebreakerTopec topic = icebreakerTopecRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Тема с id " + id + " не найдена"));
        topic.setText(newText);
        return icebreakerTopecRepository.save(topic);
    }

    @Transactional
    public List<IcebreakerTopec> findTopicsByText(String text) {
        String safeText = escapeForLike(text);
        return icebreakerTopecRepository.findByTextContainingIgnoreCase(safeText);
    }

    private String escapeForLike(String input) {
        return input.replace("\\", "\\\\")
                .replace("%", "\\%")
                .replace("_", "\\_");
    }
}