package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.efedotov.meet_now.meet_now.model.user.Purpose;

public interface PurposeRepository extends JpaRepository<Purpose, UUID> {
    Page<Purpose> findByTitleContainingIgnoreCase(String title, Pageable pageable);

    Optional<Purpose> findByTitle(String title);

    Optional<Purpose> findByTitleIgnoreCase(String title);

    boolean existsByTitleIgnoreCase(String title);

    List<Purpose> findByTitleIn(List<String> titles);

    @Query("SELECT p FROM Purpose p WHERE LOWER(p.title) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Purpose> searchByTitle(@Param("query") String query);
}