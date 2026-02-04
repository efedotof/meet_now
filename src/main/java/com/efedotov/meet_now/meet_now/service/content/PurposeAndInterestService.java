package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.request.content.InterestCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.InterestUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.PurposeCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.content.PurposeUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.content.PurposeInterestStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.user.Interest;
import com.efedotov.meet_now.meet_now.model.user.Purpose;
import com.efedotov.meet_now.meet_now.repository.user.InterestRepository;
import com.efedotov.meet_now.meet_now.repository.user.PurposeRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class PurposeAndInterestService {
    private final InterestRepository interestRepository;
    private final PurposeRepository purposeRepository;
    private final UserRepository userRepository;

    @AdminOnly
    public Page<Interest> getAllInterestsWithPagination(int page, int size, String search) {
        Pageable pageable = PageRequest.of(page, size);

        if (search != null && !search.trim().isEmpty()) {
            return interestRepository.findByTitleContainingIgnoreCase(search.trim(), pageable);
        }

        return interestRepository.findAll(pageable);
    }

    @AdminOnly
    @Transactional
    public Interest createInterest(InterestCreateRequest request) {
        if (interestRepository.existsByTitleIgnoreCase(request.getTitle())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Интерес с названием '" + request.getTitle() + "' уже существует");
        }

        Interest interest = new Interest();
        interest.setTitle(request.getTitle());

        Interest savedInterest = interestRepository.save(interest);
        log.info("Создан новый интерес: {}", savedInterest.getTitle());

        return savedInterest;
    }

    @AdminOnly
    @Transactional
    public Interest updateInterest(UUID interestId, InterestUpdateRequest request) {
        Interest interest = interestRepository.findById(interestId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Интерес не найден"));

        if (request.getTitle() != null &&
                !request.getTitle().equals(interest.getTitle()) &&
                interestRepository.existsByTitleIgnoreCase(request.getTitle())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Интерес с названием '" + request.getTitle() + "' уже существует");
        }

        if (request.getTitle() != null) {
            interest.setTitle(request.getTitle());
        }

        Interest updatedInterest = interestRepository.save(interest);
        log.info("Обновлен интерес: ID {}", interestId);

        return updatedInterest;
    }

    @AdminOnly
    @Transactional
    public void deleteInterest(UUID interestId) {
        Interest interest = interestRepository.findById(interestId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Интерес не найден"));

        long usersWithInterest = userRepository.countByInterestsContaining(interest.getTitle());
        if (usersWithInterest > 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Невозможно удалить интерес: " + usersWithInterest + " пользователей имеют этот интерес");
        }

        interestRepository.delete(interest);
        log.info("Удален интерес: {}", interest.getTitle());
    }

    @AdminOnly
    public Interest getInterestById(UUID interestId) {
        return interestRepository.findById(interestId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Интерес не найден"));
    }

    @AdminOnly
    public Page<Purpose> getAllPurposesWithPagination(int page, int size, String search) {
        Pageable pageable = PageRequest.of(page, size);

        if (search != null && !search.trim().isEmpty()) {
            return purposeRepository.findByTitleContainingIgnoreCase(search.trim(), pageable);
        }

        return purposeRepository.findAll(pageable);
    }

    @AdminOnly
    @Transactional
    public Purpose createPurpose(PurposeCreateRequest request) {
        if (purposeRepository.existsByTitleIgnoreCase(request.getTitle())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Цель с названием '" + request.getTitle() + "' уже существует");
        }

        Purpose purpose = new Purpose();
        purpose.setTitle(request.getTitle());

        Purpose savedPurpose = purposeRepository.save(purpose);
        log.info("Создана новая цель: {}", savedPurpose.getTitle());

        return savedPurpose;
    }

    @AdminOnly
    @Transactional
    public Purpose updatePurpose(UUID purposeId, PurposeUpdateRequest request) {
        Purpose purpose = purposeRepository.findById(purposeId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Цель не найдена"));

        if (request.getTitle() != null &&
                !request.getTitle().equals(purpose.getTitle()) &&
                purposeRepository.existsByTitleIgnoreCase(request.getTitle())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Цель с названием '" + request.getTitle() + "' уже существует");
        }

        if (request.getTitle() != null) {
            purpose.setTitle(request.getTitle());
        }

        Purpose updatedPurpose = purposeRepository.save(purpose);
        log.info("Обновлена цель: ID {}", purposeId);

        return updatedPurpose;
    }

    @AdminOnly
    @Transactional
    public void deletePurpose(UUID purposeId) {
        Purpose purpose = purposeRepository.findById(purposeId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Цель не найдена"));

        long usersWithPurpose = userRepository.countByPurpose(purpose.getTitle());
        if (usersWithPurpose > 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Невозможно удалить цель: " + usersWithPurpose + " пользователей имеют эту цель");
        }

        purposeRepository.delete(purpose);
        log.info("Удалена цель: {}", purpose.getTitle());
    }

    @AdminOnly
    public Purpose getPurposeById(UUID purposeId) {
        return purposeRepository.findById(purposeId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Цель не найдена"));
    }

    @AdminOnly
    public PurposeInterestStatisticsResponse getPurposeInterestStatistics() {
        long totalInterests = interestRepository.count();
        long totalPurposes = purposeRepository.count();

        List<Object[]> popularInterestsRaw = userRepository.findMostPopularInterests();
        List<String> popularInterests = popularInterestsRaw.stream()
                .map(obj -> (String) obj[0])
                .collect(Collectors.toList());

        List<Object[]> popularPurposesRaw = userRepository.findMostPopularPurposes();
        List<String> popularPurposes = popularPurposesRaw.stream()
                .map(obj -> (String) obj[0])
                .collect(Collectors.toList());

        return PurposeInterestStatisticsResponse.builder()
                .totalInterests(totalInterests)
                .totalPurposes(totalPurposes)
                .popularInterests(popularInterests)
                .popularPurposes(popularPurposes)
                .build();
    }

    @AdminOnly
    @Transactional
    public void bulkDeleteInterests(List<UUID> interestIds) {
        if (interestIds == null || interestIds.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Список ID интересов не может быть пустым");
        }

        long deletedCount = 0;
        for (UUID interestId : interestIds) {
            try {
                deleteInterest(interestId);
                deletedCount++;
            } catch (Exception e) {
                log.warn("Не удалось удалить интерес с ID {}: {}", interestId, e.getMessage());
            }
        }

        log.info("Удалено {} интересов из {}", deletedCount, interestIds.size());
    }

    @AdminOnly
    @Transactional
    public void bulkDeletePurposes(List<UUID> purposeIds) {
        if (purposeIds == null || purposeIds.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Список ID целей не может быть пустым");
        }

        long deletedCount = 0;
        for (UUID purposeId : purposeIds) {
            try {
                deletePurpose(purposeId);
                deletedCount++;
            } catch (Exception e) {
                log.warn("Не удалось удалить цель с ID {}: {}", purposeId, e.getMessage());
            }
        }

        log.info("Удалено {} целей из {}", deletedCount, purposeIds.size());
    }

    @AdminOnly
    public List<Interest> exportAllInterests() {
        return interestRepository.findAll();
    }

    @AdminOnly
    public List<Purpose> exportAllPurposes() {
        return purposeRepository.findAll();
    }

    public List<Interest> getAllInterest() {
        return interestRepository.findAll();
    }

    public List<Purpose> getAllPurpose() {
        return purposeRepository.findAll();
    }

    public List<String> searchInterestTitles(String query) {
        if (query == null || query.trim().isEmpty()) {
            return interestRepository.findAll().stream()
                    .map(Interest::getTitle)
                    .collect(Collectors.toList());
        }
        
        return interestRepository.findByTitleContainingIgnoreCase(query.trim(), Pageable.unpaged())
                .stream()
                .map(Interest::getTitle)
                .collect(Collectors.toList());
    }

    public List<String> searchPurposeTitles(String query) {
        if (query == null || query.trim().isEmpty()) {
            return purposeRepository.findAll().stream()
                    .map(Purpose::getTitle)
                    .collect(Collectors.toList());
        }
        
        return purposeRepository.findByTitleContainingIgnoreCase(query.trim(), Pageable.unpaged())
                .stream()
                .map(Purpose::getTitle)
                .collect(Collectors.toList());
    }

    public Optional<Interest> getInterestByTitle(String title) {
        return interestRepository.findByTitleIgnoreCase(title);
    }

    public Optional<Purpose> getPurposeByTitle(String title) {
        return purposeRepository.findByTitleIgnoreCase(title);
    }

    public boolean interestExists(String title) {
        return interestRepository.existsByTitleIgnoreCase(title);
    }

    public boolean purposeExists(String title) {
        return purposeRepository.existsByTitleIgnoreCase(title);
    }
}