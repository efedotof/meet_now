package com.efedotov.meet_now.meet_now.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.efedotov.meet_now.meet_now.model.Purpose;

public interface PurposeRepository extends JpaRepository<Purpose, UUID> {

}
