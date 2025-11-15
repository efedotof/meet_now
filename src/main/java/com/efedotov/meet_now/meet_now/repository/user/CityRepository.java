package com.efedotov.meet_now.meet_now.repository.user;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.efedotov.meet_now.meet_now.dto.response.city.CityCountDTO;
import com.efedotov.meet_now.meet_now.model.user.City;

public interface CityRepository extends JpaRepository<City, UUID> {

    List<City> findByNameCityContainingIgnoreCase(String name);

    Page<City> findByNameCityContainingIgnoreCase(String name, Pageable pageable);

    List<City> findByNameCityStartingWithIgnoreCase(String prefix);

    @Query("SELECT c FROM City c WHERE LOWER(c.nameCity) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<City> searchByName(@Param("query") String query);

    @Query("SELECT c FROM City c WHERE LOWER(c.nameCity) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<City> searchByNameLimited(@Param("query") String query, Pageable pageable);

    boolean existsByNameCityIgnoreCase(String name);

    @Query("SELECT COUNT(DISTINCT u.city) FROM User u WHERE u.city IS NOT NULL AND u.city != ''")
    long countCitiesWithUsers();

    @Query("SELECT NEW com.efedotov.meet_now.meet_now.dto.response.city.CityCountDTO(u.city, COUNT(u)) " +
            "FROM User u WHERE u.city IS NOT NULL AND u.city != '' GROUP BY u.city ORDER BY COUNT(u) DESC")
    List<CityCountDTO> getCitiesUsageStatistics();
}