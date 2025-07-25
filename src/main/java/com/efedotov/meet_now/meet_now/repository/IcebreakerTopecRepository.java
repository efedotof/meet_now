package com.efedotov.meet_now.meet_now.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.IcebreakerTopec;

@Repository
public interface IcebreakerTopecRepository extends JpaRepository<IcebreakerTopec, Long> {

    @Query("SELECT t FROM IcebreakerTopec t " +
            "WHERE LOWER(t.text) LIKE LOWER(CONCAT('%', :text, '%')) ESCAPE '\\'")
    List<IcebreakerTopec> findByTextContainingIgnoreCase(@Param("text") String text);

}
