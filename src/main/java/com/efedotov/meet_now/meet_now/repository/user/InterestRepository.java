package com.efedotov.meet_now.meet_now.repository.user;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.efedotov.meet_now.meet_now.model.user.Interest;

public interface InterestRepository extends JpaRepository<Interest, UUID> {

}
