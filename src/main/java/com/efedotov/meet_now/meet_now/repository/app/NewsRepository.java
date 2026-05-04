package com.efedotov.meet_now.meet_now.repository.app;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.app.News;

@Repository
public interface NewsRepository extends JpaRepository<News, Long> {
    List<News> findAllByIsActiveTrueOrderBySortOrderAsc();
}