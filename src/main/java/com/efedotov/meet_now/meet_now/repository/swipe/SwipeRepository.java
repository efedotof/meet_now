package com.efedotov.meet_now.meet_now.repository.swipe;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.swipe.Swipe;
import com.efedotov.meet_now.meet_now.model.swipe.SwipeAction;

@Repository
public interface SwipeRepository extends JpaRepository<Swipe, UUID> {
    Optional<Swipe> findBySwiperIdAndTargetId(UUID swiperId, UUID targetId);

    boolean existsBySwiperIdAndTargetId(UUID swiperId, UUID targetId);

    List<Swipe> findByTargetIdAndAction(UUID targetId, SwipeAction action);
}