package com.efedotov.meet_now.meet_now.service;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.repository.CityRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CityService {
    private final CityRepository cityRepository;
    
    public List<String> searchCities(String query) {
        return cityRepository.findByNameCityContainingIgnoreCase(query)
                .stream()
                .map(city -> city.getNameCity())
                .toList();
    }
    
    public List<String> searchCitiesLimited(String query, int limit) {
        return cityRepository.searchByNameLimited(query, PageRequest.of(0, limit))
                .stream()
                .map(city -> city.getNameCity())
                .toList();
    }

    public List<String> searchCitiesByPrefix(String prefix) {
        return cityRepository.findByNameCityStartingWithIgnoreCase(prefix)
                .stream()
                .map(city -> city.getNameCity())
                .toList();
    }
    
    public List<String> searchCitiesByPrefixLimited(String prefix, int limit) {
        return cityRepository.findByNameCityStartingWithIgnoreCase(prefix)
                .stream()
                .limit(limit)
                .map(city -> city.getNameCity())
                .toList();
    }
}