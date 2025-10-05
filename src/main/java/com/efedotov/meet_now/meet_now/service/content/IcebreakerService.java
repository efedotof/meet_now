package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Random;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.content.IcebreakerTopec;
import com.efedotov.meet_now.meet_now.repository.content.IcebreakerTopicRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class IcebreakerService {

    private final IcebreakerTopicRepository icebreakerTopecRepository;
    private final Random random = new Random();

    // Получить список всех тем.
    public List<IcebreakerTopec> getAllTopics() {
        return icebreakerTopecRepository.findAll();
    }

    // Получить случайную тему из всех доступных.
    public IcebreakerTopec getRandomTopic() {
        List<IcebreakerTopec> allTopics = icebreakerTopecRepository.findAll();
        if (allTopics.isEmpty()) {
            throw new NoSuchElementException("Темы для общения не найдены");
        }
        int index = random.nextInt(allTopics.size());
        return allTopics.get(index);
    }

    // Добавить новую тему.
    @Transactional
    public IcebreakerTopec addTopic(String text) {
        IcebreakerTopec topic = new IcebreakerTopec();
        topic.setText(text);
        return icebreakerTopecRepository.save(topic);
    }

    // Обновить существующую тему по id.
    @Transactional
    public IcebreakerTopec updateTopic(Long id, String newText) {
        IcebreakerTopec topic = icebreakerTopecRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Тема с id " + id + " не найдена"));
        topic.setText(newText);
        return icebreakerTopecRepository.save(topic);
    }

    // Удалить тему по id.
    @Transactional
    public void deleteTopic(Long id) {
        if (!icebreakerTopecRepository.existsById(id)) {
            throw new NoSuchElementException("Тема с id " + id + " не найдена");
        }
        icebreakerTopecRepository.deleteById(id);
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
