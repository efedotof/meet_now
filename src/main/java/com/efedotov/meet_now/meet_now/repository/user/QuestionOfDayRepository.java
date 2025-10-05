package com.efedotov.meet_now.meet_now.repository.user;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.user.QuestionOfDay;

@Repository
public interface QuestionOfDayRepository extends JpaRepository<QuestionOfDay, Long> {
    Optional<QuestionOfDay> findByDate(java.time.LocalDate date);
}
