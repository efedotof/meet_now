package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.request.city.CityCreateRequest;
import com.efedotov.meet_now.meet_now.dto.request.city.CityUpdateRequest;
import com.efedotov.meet_now.meet_now.dto.response.city.CityCountDTO;
import com.efedotov.meet_now.meet_now.dto.response.city.CityStatisticsResponse;
import com.efedotov.meet_now.meet_now.model.user.City;
import com.efedotov.meet_now.meet_now.repository.user.CityRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class CityService {
    private final CityRepository cityRepository;
    private final UserRepository userRepository;

    @AdminOnly
    public Page<City> getAllCities(int page, int size, String search) {
        Pageable pageable = PageRequest.of(page, size);

        if (search != null && !search.trim().isEmpty()) {
            return cityRepository.findByNameCityContainingIgnoreCase(search.trim(), pageable);
        }

        return cityRepository.findAll(pageable);
    }

    @AdminOnly
    public CityStatisticsResponse getCityStatistics() {
        long totalCities = cityRepository.count();
        long citiesWithUsers = cityRepository.countCitiesWithUsers();

        List<CityCountDTO> popularCities = userRepository.countUsersByCity();
        List<CityCountDTO> citiesUsage = cityRepository.getCitiesUsageStatistics();

        return CityStatisticsResponse.builder()
                .totalCities(totalCities)
                .citiesWithUsers(citiesWithUsers)
                .citiesWithoutUsers(totalCities - citiesWithUsers)
                .popularCities(popularCities)
                .citiesUsage(citiesUsage)
                .build();
    }

    @AdminOnly
    @Transactional
    public City createCity(CityCreateRequest request) {
        if (cityRepository.existsByNameCityIgnoreCase(request.getName())) {
            throw new IllegalArgumentException("Город с названием '" + request.getName() + "' уже существует");
        }

        City city = new City();
        city.setNameCity(request.getName());

        return cityRepository.save(city);
    }

    @AdminOnly
    @Transactional
    public City updateCity(UUID cityId, CityUpdateRequest request) {
        City city = cityRepository.findById(cityId)
                .orElseThrow(() -> new IllegalArgumentException("Город не найден: " + cityId));

        if (request.getName() != null &&
                !request.getName().equalsIgnoreCase(city.getNameCity()) &&
                cityRepository.existsByNameCityIgnoreCase(request.getName())) {
            throw new IllegalArgumentException("Город с названием '" + request.getName() + "' уже существует");
        }

        if (request.getName() != null) {
            city.setNameCity(request.getName());
        }

        return cityRepository.save(city);
    }

    @AdminOnly
    @Transactional
    public void deleteCity(UUID cityId) {
        City city = cityRepository.findById(cityId)
                .orElseThrow(() -> new IllegalArgumentException("Город не найден: " + cityId));

        long usersInCity = userRepository.countByCityName(city.getNameCity());
        if (usersInCity > 0) {
            throw new IllegalStateException(
                    "Невозможно удалить город: " + usersInCity + " пользователей привязано к этому городу");
        }

        cityRepository.delete(city);
        log.info("Город удален: {}", city.getNameCity());
    }

    @AdminOnly
    @Transactional
    public void bulkDeleteCities(List<UUID> cityIds) {
        if (cityIds == null || cityIds.isEmpty()) {
            throw new IllegalArgumentException("Список ID городов не может быть пустым");
        }

        long deletedCount = 0;
        for (UUID cityId : cityIds) {
            try {
                deleteCity(cityId);
                deletedCount++;
            } catch (Exception e) {
                log.warn("Не удалось удалить город с ID {}: {}", cityId, e.getMessage());
            }
        }

        log.info("Удалено {} городов из {}", deletedCount, cityIds.size());
    }

    @AdminOnly
    public City getCityById(UUID cityId) {
        return cityRepository.findById(cityId)
                .orElseThrow(() -> new IllegalArgumentException("Город не найден: " + cityId));
    }

    @AdminOnly
    public List<City> exportCities() {
        return cityRepository.findAll();
    }

    public List<City> searchCities(String query) {
        return cityRepository.findByNameCityContainingIgnoreCase(query);
    }

    public List<City> searchCitiesLimited(String query, int limit) {
        return cityRepository.searchByNameLimited(query, PageRequest.of(0, limit));
    }

    public List<City> searchCitiesByPrefix(String prefix) {
        return cityRepository.findByNameCityStartingWithIgnoreCase(prefix);
    }

    public List<City> searchCitiesByPrefixLimited(String prefix, int limit) {
        return cityRepository.findByNameCityStartingWithIgnoreCase(prefix)
                .stream()
                .limit(limit)
                .toList();
    }
}