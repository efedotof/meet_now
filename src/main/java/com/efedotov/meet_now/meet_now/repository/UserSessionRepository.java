package com.efedotov.meet_now.meet_now.repository;

import com.efedotov.meet_now.meet_now.model.UserSession;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserSessionRepository extends JpaRepository<UserSession, String> {
}
