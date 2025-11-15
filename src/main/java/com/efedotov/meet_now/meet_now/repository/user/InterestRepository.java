package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.efedotov.meet_now.meet_now.model.user.Interest;

public interface InterestRepository extends JpaRepository<Interest, UUID> {
    Page<Interest> findByTitleContainingIgnoreCase(String title, Pageable pageable);

    Optional<Interest> findByTitle(String title);

    Optional<Interest> findByTitleIgnoreCase(String title);

    boolean existsByTitleIgnoreCase(String title);

    List<Interest> findByTitleIn(List<String> titles);

    @Query("SELECT i FROM Interest i WHERE LOWER(i.title) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Interest> searchByTitle(@Param("query") String query);
}