package com.efedotov.meet_now.meet_now.repository.game;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.game.GameConfigEntity;

@Repository
public interface GameConfigRepository extends
        JpaRepository<GameConfigEntity, String>,
        JpaSpecificationExecutor<GameConfigEntity> {

    Optional<GameConfigEntity> findByGameType(String gameType);

    List<GameConfigEntity> findByIsActiveTrue();

    boolean existsByGameType(String gameType);
}