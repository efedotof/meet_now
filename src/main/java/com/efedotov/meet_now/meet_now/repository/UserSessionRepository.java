package com.efedotov.meet_now.meet_now.repository;

import java.time.Instant;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.UserSession;

@Repository
public interface UserSessionRepository extends JpaRepository<UserSession, String> {

    Optional<UserSession> findByToken(String token);

    @Query("SELECT s FROM UserSession s WHERE s.token = ?1 AND s.expiresAt > ?2")
    Optional<UserSession> findValidSession(String token, Instant now);

    @Modifying
    @Query("DELETE FROM UserSession s WHERE s.expiresAt < ?1")
    void deleteExpiredSessions(Instant now);
}