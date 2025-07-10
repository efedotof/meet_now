package com.efedotov.meet_now.meet_now.repository;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.IcebreakerTopec;

@Repository
public interface IcebreakerTopecRepository extends JpaRepository<IcebreakerTopec, Long> {
    List<IcebreakerTopec> findByTextContainingIgnoreCase(String text);
}
