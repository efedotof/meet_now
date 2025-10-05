package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.efedotov.meet_now.meet_now.model.user.City;

public interface CityRepository extends JpaRepository<City, UUID> {
    List<City> findByNameCityContainingIgnoreCase(String name);

    List<City> findByNameCityStartingWithIgnoreCase(String prefix);

    @Query("SELECT c FROM City c WHERE LOWER(c.nameCity) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<City> searchByName(@Param("query") String query);

    @Query("SELECT c FROM City c WHERE LOWER(c.nameCity) LIKE LOWER(CONCAT('%', :query, '%')) ORDER BY c.nameCity")
    List<City> searchByNameLimited(@Param("query") String query, Pageable pageable);
}