package com.efedotov.meet_now.meet_now.controller.swipe;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.response.swipe.MatchResponse;
import com.efedotov.meet_now.meet_now.dto.response.swipe.SwipeCandidateResponse;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.swipe.SwipeService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/swipe")
@Tag(name = "Swipe", description = "Эндпоинты для режима карточек (Tinder-like свайпинг)")
@RequiredArgsConstructor
@EnableMethodSecurity
public class SwipeController {

    private final SwipeService swipeService;

    @Operation(summary = "Получить кандидата для свайпа с фильтрацией")
    @GetMapping("/candidate")
    public ResponseEntity<SwipeCandidateResponse> getCandidate(
            Authentication authentication,
            @RequestParam(required = false) String floor,
            @RequestParam(required = false) Integer minAge,
            @RequestParam(required = false) Integer maxAge,
            @RequestParam(required = false) Boolean verified,
            @RequestParam(required = false) Boolean online,
            @RequestParam(required = false) List<String> interests,
            @RequestParam(required = false) List<String> purposes) {
        UUID currentUserId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        Optional<SwipeCandidateResponse> candidate = swipeService.getCandidate(
                currentUserId, floor, minAge, maxAge, verified, online, interests, purposes);
        return candidate.map(ResponseEntity::ok)
                .orElse(ResponseEntity.noContent().build());
    }

    @Operation(summary = "Поставить лайк пользователю")
    @PostMapping("/like/{targetId}")
    public ResponseEntity<?> likeUser(@PathVariable UUID targetId, Authentication authentication) {
        UUID currentUserId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        Optional<MatchResponse> match = swipeService.likeUser(currentUserId, targetId);
        if (match.isPresent()) {
            return ResponseEntity.ok(match.get());
        } else {
            return ResponseEntity.ok().body("Liked");
        }
    }

    @Operation(summary = "Поставить дизлайк пользователю")
    @PostMapping("/dislike/{targetId}")
    public ResponseEntity<String> dislikeUser(@PathVariable UUID targetId, Authentication authentication) {
        UUID currentUserId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        swipeService.dislikeUser(currentUserId, targetId);
        return ResponseEntity.ok("Disliked");
    }

    @Operation(summary = "Получить список матчей текущего пользователя")
    @GetMapping("/matches")
    public ResponseEntity<List<MatchResponse>> getMatches(Authentication authentication) {
        UUID currentUserId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        List<MatchResponse> matches = swipeService.getMatches(currentUserId);
        return ResponseEntity.ok(matches);
    }
}