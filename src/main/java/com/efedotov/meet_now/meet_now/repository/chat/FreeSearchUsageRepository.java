package com.efedotov.meet_now.meet_now.repository.chat;

import org.springframework.data.jpa.repository.JpaRepository;

import com.efedotov.meet_now.meet_now.model.user.FreeSearchUsage;

import java.util.UUID;

public interface FreeSearchUsageRepository extends JpaRepository<FreeSearchUsage, UUID> {
}