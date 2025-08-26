package com.efedotov.meet_now.meet_now.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.Interest;
import com.efedotov.meet_now.meet_now.model.Purpose;
import com.efedotov.meet_now.meet_now.repository.InterestRepository;
import com.efedotov.meet_now.meet_now.repository.PurposeRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PurpAndIntService {
    private final InterestRepository interestRepository;
    private final PurposeRepository purposeRepository;

    public List<Interest> getAllInterest() {
        List<Interest> interests = interestRepository.findAll();
        return interests;
    }

    public List<Purpose> getAllPurpose() {
        List<Purpose> purposes = purposeRepository.findAll();
        return purposes;
    }
}
