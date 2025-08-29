package com.efedotov.meet_now.meet_now.service;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.City;
import com.efedotov.meet_now.meet_now.repository.CityRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CityService {
    private final CityRepository cityRepository;
    
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