package com.efedotov.meet_now.meet_now.repository.content;

import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.content.IcebreakerTopec;

@Repository
public interface IcebreakerTopicRepository extends JpaRepository<IcebreakerTopec, Long> {

        @Query("SELECT t FROM IcebreakerTopec t " +
                        "WHERE LOWER(t.text) LIKE LOWER(CONCAT('%', :text, '%')) ESCAPE '\\'")
        List<IcebreakerTopec> findByTextContainingIgnoreCase(@Param("text") String text);

        @Query("SELECT t FROM IcebreakerTopec t " +
                        "WHERE LOWER(t.text) LIKE LOWER(CONCAT('%', :text, '%')) ESCAPE '\\'")
        Page<IcebreakerTopec> findByTextContainingIgnoreCase(@Param("text") String text, Pageable pageable);

        boolean existsByTextIgnoreCase(String text);

        @Override
        long count();

        @Query("SELECT COUNT(t) FROM IcebreakerTopec t WHERE LENGTH(t.text) > :length")
        long countByTextLengthGreaterThan(@Param("length") int length);

        @Query("SELECT t FROM IcebreakerTopec t ORDER BY LENGTH(t.text) DESC LIMIT 5")
        List<IcebreakerTopec> findTop5ByOrderByTextLengthDesc();
}