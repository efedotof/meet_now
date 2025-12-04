package com.efedotov.meet_now.meet_now.service.moderation;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.efedotov.meet_now.meet_now.dto.request.moderation.CreateAnswerRequest;
import com.efedotov.meet_now.meet_now.dto.request.moderation.CreateQuestionRequest;
import com.efedotov.meet_now.meet_now.dto.response.moderation.DailyQuestionStatisticDto;
import com.efedotov.meet_now.meet_now.dto.response.moderation.QuestionDTO;
import com.efedotov.meet_now.meet_now.dto.response.moderation.SupportStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.moderation.UserQuestionStatisticDto;
import com.efedotov.meet_now.meet_now.model.moderation.Answer;
import com.efedotov.meet_now.meet_now.model.moderation.Question;
import com.efedotov.meet_now.meet_now.model.moderation.QuestionStatus;
import com.efedotov.meet_now.meet_now.repository.moderation.AnswerRepository;
import com.efedotov.meet_now.meet_now.repository.moderation.QuestionRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.social.UserService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class SupportService {
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;
    private final UserService userService;

    @AdminOnly
    public SupportStatisticsDto getSupportStatistics() {
        SupportStatisticsDto statistics = new SupportStatisticsDto(); 

        statistics.setTotalQuestions(questionRepository.count());
        statistics.setTotalAnswers(answerRepository.count());

        statistics.setPendingQuestions(questionRepository.countByStatus(QuestionStatus.PENDING.toString()));
        statistics.setResolvedQuestions(questionRepository.countByStatus(QuestionStatus.RESOLVED.toString()));

        statistics.setUnansweredQuestions(questionRepository.countByAnswersIsEmpty());

        statistics.setAverageResponseTimeHours(calculateAverageResponseTime());

        statistics.setMostActiveUsers(getTopQuestionUsers(5));

        statistics.setQuestionsLast7Days(getQuestionsLast7Days());

        log.info("Admin requested support statistics");
        return statistics;
    }

    @AdminOnly
    public Page<QuestionDTO> getAllQuestionsPaginated(QuestionStatus status, Pageable pageable) {
        Page<Question> questions;
        if (status != null) {
            questions = questionRepository.findByStatus(status, pageable);
        } else {
            questions = questionRepository.findAll(pageable);
        }

        return questions.map(this::convertToDTO);
    }

    @AdminOnly
    public void deleteQuestion(UUID questionId) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));

        answerRepository.deleteByQuestionId(questionId);

        questionRepository.delete(question);

        log.info("Admin deleted question {}", questionId);
    }

    @AdminOnly
    public void deleteAnswer(UUID answerId) {
        Answer answer = answerRepository.findById(answerId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Answer not found"));

        answerRepository.delete(answer);
        log.info("Admin deleted answer {}", answerId);
    }

    @AdminOnly
    public Question forceCloseQuestion(UUID questionId) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));

        question.setStatus(QuestionStatus.RESOLVED);
        question.setUpdatedAt(LocalDateTime.now());

        log.info("Admin force-closed question {}", questionId);
        return questionRepository.save(question);
    }

    @AdminOnly
    public List<Question> getUserQuestionsByAdmin(UUID userId) {
        return questionRepository.findByUserId(userId);
    }

    @AdminOnly
    public List<UserQuestionStatisticDto> getMostActiveSupportUsers(int limit) {
        List<Object[]> userQuestionCounts = questionRepository.countQuestionsByUser();

        return userQuestionCounts.stream()
                .limit(limit)
                .map(result -> UserQuestionStatisticDto.builder()
                        .userId((UUID) result[0])
                        .questionCount((Long) result[1])
                        .build())
                .collect(Collectors.toList());
    }

    @AdminOnly
    public List<Question> getUnansweredQuestions() {
        return questionRepository.findByAnswersIsEmpty();
    }

    public Question createQuestion(CreateQuestionRequest request, Authentication authentication) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        Question question = new Question();
        question.setTitle(request.getTitle());
        question.setDescription(request.getDescription());
        question.setStatus(QuestionStatus.PENDING);
        question.setUserId(userId);
        return questionRepository.save(question);
    }

    public Answer addAnswerToQuestion(UUID questionId, CreateAnswerRequest request, UUID userId) {
        if (!userService.hasModerationRole(userId)) {
            throw new AccessDeniedException("Only moderators and admins can add answers");
        }

        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));

        Answer answer = new Answer();
        answer.setQuestion(question);
        answer.setContent(request.getContent());
        answer.setCreatedBy(userId);

        question.setStatus(QuestionStatus.RESOLVED);
        questionRepository.save(question);

        return answerRepository.save(answer);
    }

    public List<Question> getAllQuestions() {
        return questionRepository.findAll();
    }

    public Question getQuestionById(UUID id) {
        return questionRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));
    }

    public Question updateQuestionStatus(UUID id, QuestionStatus status, UUID userId) {
        if (!userService.hasModerationRole(userId)) {
            throw new AccessDeniedException("Only moderators and admins can update question status");
        }

        Question question = getQuestionById(id);
        question.setStatus(status);
        return questionRepository.save(question);
    }

    public List<Question> getUserQuestions(UUID userId) {
        return questionRepository.findByUserId(userId);
    }

    private double calculateAverageResponseTime() {
        List<Question> resolvedQuestions = questionRepository.findByStatus(QuestionStatus.RESOLVED);

        if (resolvedQuestions.isEmpty()) {
            return 0.0;
        }

        double totalHours = resolvedQuestions.stream()
                .filter(question -> question.getAnswers() != null && !question.getAnswers().isEmpty())
                .mapToDouble(question -> {
                    LocalDateTime questionTime = question.getCreatedAt();
                    LocalDateTime firstAnswerTime = question.getAnswers().stream()
                            .map(Answer::getCreatedAt)
                            .min(LocalDateTime::compareTo)
                            .orElse(questionTime);

                    return ChronoUnit.HOURS.between(questionTime, firstAnswerTime);
                })
                .sum();

        return totalHours / resolvedQuestions.size();
    }

    private List<UserQuestionStatisticDto> getTopQuestionUsers(int limit) {
        List<Object[]> userQuestionCounts = questionRepository.countQuestionsByUser();

        return userQuestionCounts.stream()
                .limit(limit)
                .map(result -> UserQuestionStatisticDto.builder()
                        .userId((UUID) result[0])
                        .questionCount((Long) result[1])
                        .build())
                .collect(Collectors.toList());
    }

    private List<DailyQuestionStatisticDto> getQuestionsLast7Days() {
        LocalDateTime now = LocalDateTime.now();

        return java.util.stream.IntStream.rangeClosed(0, 6)
                .mapToObj(i -> {
                    LocalDateTime startOfDay = now.minusDays(i).toLocalDate().atStartOfDay();
                    LocalDateTime endOfDay = startOfDay.plusDays(1);

                    long count = questionRepository.countByCreatedAtBetween(startOfDay, endOfDay);
                    String dateKey = startOfDay.toLocalDate().toString();

                    return DailyQuestionStatisticDto.builder()
                            .date(dateKey)
                            .count(count)
                            .build();
                })
                .collect(Collectors.toList());
    }

    private QuestionDTO convertToDTO(Question question) {
        QuestionDTO dto = new QuestionDTO();
        dto.setId(question.getId());
        dto.setTitle(question.getTitle());
        dto.setDescription(question.getDescription());
        dto.setStatus(question.getStatus());
        dto.setUserId(question.getUserId());
        dto.setCreatedAt(question.getCreatedAt());
        dto.setUpdatedAt(question.getUpdatedAt());

        if (question.getAnswers() != null) {
            dto.setAnswers(question.getAnswers().stream()
                    .map(this::convertToAnswerDTO)
                    .collect(Collectors.toList()));
        }

        return dto;
    }

    private com.efedotov.meet_now.meet_now.dto.response.moderation.AnswerDTO convertToAnswerDTO(Answer answer) {
        com.efedotov.meet_now.meet_now.dto.response.moderation.AnswerDTO dto = new com.efedotov.meet_now.meet_now.dto.response.moderation.AnswerDTO();
        dto.setId(answer.getId());
        dto.setContent(answer.getContent());
        dto.setCreatedBy(answer.getCreatedBy());
        dto.setCreatedAt(answer.getCreatedAt());
        return dto;
    }
}