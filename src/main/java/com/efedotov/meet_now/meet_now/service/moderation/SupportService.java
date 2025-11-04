package com.efedotov.meet_now.meet_now.service.moderation;

import com.efedotov.meet_now.meet_now.dto.request.moderation.CreateAnswerRequest;
import com.efedotov.meet_now.meet_now.dto.request.moderation.CreateQuestionRequest;
import com.efedotov.meet_now.meet_now.model.moderation.Answer;
import com.efedotov.meet_now.meet_now.model.moderation.Question;
import com.efedotov.meet_now.meet_now.model.moderation.QuestionStatus;
import com.efedotov.meet_now.meet_now.repository.moderation.AnswerRepository;
import com.efedotov.meet_now.meet_now.repository.moderation.QuestionRepository;
import com.efedotov.meet_now.meet_now.service.social.UserService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor
public class SupportService {
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;
    private final UserService userService;

    public Question createQuestion(CreateQuestionRequest request, UUID userId) {
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
}