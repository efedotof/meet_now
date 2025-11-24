package com.efedotov.meet_now.meet_now.repository.moderation;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.moderation.Question;
import com.efedotov.meet_now.meet_now.model.moderation.QuestionStatus;

@Repository
public interface QuestionRepository extends JpaRepository<Question, UUID> {
    List<Question> findByStatus(QuestionStatus status);

    List<Question> findByUserId(UUID userId);

    Page<Question> findByStatus(QuestionStatus status, Pageable pageable);

    @Query(value = "SELECT COUNT(*) FROM questions WHERE status = :status", nativeQuery = true)
    long countByStatus(@Param("status") String status);

    @Query("SELECT COUNT(q) FROM Question q WHERE q.answers IS EMPTY")
    long countByAnswersIsEmpty();

    @Query("SELECT q.userId, COUNT(q) FROM Question q GROUP BY q.userId ORDER BY COUNT(q) DESC")
    List<Object[]> countQuestionsByUser();

    List<Question> findByAnswersIsEmpty();

    long countByCreatedAtBetween(LocalDateTime start, LocalDateTime end);
}