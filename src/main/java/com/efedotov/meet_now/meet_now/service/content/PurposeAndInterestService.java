package com.efedotov.meet_now.meet_now.service.content;

import java.util.List;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.model.user.Interest;
import com.efedotov.meet_now.meet_now.model.user.Purpose;
import com.efedotov.meet_now.meet_now.repository.user.InterestRepository;
import com.efedotov.meet_now.meet_now.repository.user.PurposeRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PurposeAndInterestService {
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
