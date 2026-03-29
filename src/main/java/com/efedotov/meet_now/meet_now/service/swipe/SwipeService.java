package com.efedotov.meet_now.meet_now.service.swipe;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.response.swipe.MatchResponse;
import com.efedotov.meet_now.meet_now.dto.response.swipe.SwipeCandidateResponse;
import com.efedotov.meet_now.meet_now.dto.response.swipe.UserLikeResponse;
import com.efedotov.meet_now.meet_now.exception.UnauthorizedException;
import com.efedotov.meet_now.meet_now.model.swipe.Match;
import com.efedotov.meet_now.meet_now.model.swipe.Swipe;
import com.efedotov.meet_now.meet_now.model.swipe.SwipeAction;
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.swipe.MatchRepository;
import com.efedotov.meet_now.meet_now.repository.swipe.SwipeRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;
import com.efedotov.meet_now.meet_now.service.notification.InternalNotificationService;
import com.efedotov.meet_now.meet_now.service.social.FriendService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class SwipeService {

    private final UserRepository userRepository;
    private final SwipeRepository swipeRepository;
    private final MatchRepository matchRepository;
    private final ChatService chatService;
    private final FriendService friendService;
    private final InternalNotificationService internalNotificationService;

    private void checkAccess(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UnauthorizedException("User not found"));
        boolean hasPremium = user.getRoles().stream()
                .anyMatch(role -> "PREMIUM".equals(role.getRoleName()));
        if (!hasPremium || !Boolean.TRUE.equals(user.getIsCardMode())) {
            throw new UnauthorizedException("Card mode is not available for this user");
        }
    }

    @Transactional(readOnly = true)
    public Optional<SwipeCandidateResponse> getCandidate(
            UUID currentUserId,
            String floor,
            Integer minAge,
            Integer maxAge,
            Boolean verified,
            Boolean online,
            List<String> interests,
            List<String> purposes) {
        checkAccess(currentUserId);

        if (floor != null && floor.trim().isEmpty()) {
            floor = null;
        }
        if (interests != null) {
            interests = interests.stream()
                    .filter(i -> i != null && !i.trim().isEmpty())
                    .collect(Collectors.toList());
            if (interests.isEmpty()) {
                interests = null;
            }
        }
        if (purposes != null) {
            purposes = purposes.stream()
                    .filter(p -> p != null && !p.trim().isEmpty())
                    .collect(Collectors.toList());
            if (purposes.isEmpty()) {
                purposes = null;
            }
        }

        boolean interestsEmpty = interests == null || interests.isEmpty();
        boolean purposesEmpty = purposes == null || purposes.isEmpty();
        boolean onlineOnly = online != null && online;

        return userRepository.findRandomCardModeCandidateWithFilters(
                currentUserId,
                floor,
                verified,
                onlineOnly,
                minAge,
                maxAge,
                interests != null ? interests : Collections.emptyList(),
                purposes != null ? purposes : Collections.emptyList(),
                interestsEmpty,
                purposesEmpty).map(this::mapToSwipeCandidateResponse);
    }

    @Transactional
    public Optional<MatchResponse> likeUser(UUID currentUserId, UUID targetId) {
        checkAccess(currentUserId);

        User target = userRepository.findById(targetId)
                .orElseThrow(() -> new IllegalArgumentException("Target user not found"));

        if (currentUserId.equals(targetId)) {
            throw new IllegalArgumentException("Cannot like yourself");
        }

        if (swipeRepository.existsBySwiperIdAndTargetId(currentUserId, targetId)) {
            throw new IllegalStateException("You have already swiped this user");
        }

        Swipe swipe = new Swipe();
        swipe.setSwiperId(currentUserId);
        swipe.setTargetId(targetId);
        swipe.setAction(SwipeAction.LIKE);
        swipeRepository.save(swipe);

        User currentUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new IllegalArgumentException("Current user not found"));

        Optional<Swipe> mutualLike = swipeRepository.findBySwiperIdAndTargetId(targetId, currentUserId)
                .filter(s -> s.getAction() == SwipeAction.LIKE);

        if (mutualLike.isPresent()) {
            UUID user1 = currentUserId.compareTo(targetId) < 0 ? currentUserId : targetId;
            UUID user2 = currentUserId.compareTo(targetId) < 0 ? targetId : currentUserId;
            Match match = new Match();
            match.setUser1Id(user1);
            match.setUser2Id(user2);
            matchRepository.save(match);

            chatService.createOrGetPermanentChat(currentUserId, targetId);
            friendService.sendFriendRequest(currentUserId, targetId);

            return Optional.of(mapToMatchResponse(match, target));
        } else {
            internalNotificationService.sendRatingNotification(targetId, currentUserId, currentUser.getUsername());
            return Optional.empty();
        }
    }

    @Transactional
    public void dislikeUser(UUID currentUserId, UUID targetId) {
        checkAccess(currentUserId);

        if (currentUserId.equals(targetId)) {
            throw new IllegalArgumentException("Cannot dislike yourself");
        }

        if (swipeRepository.existsBySwiperIdAndTargetId(currentUserId, targetId)) {
            throw new IllegalStateException("You have already swiped this user");
        }

        Swipe swipe = new Swipe();
        swipe.setSwiperId(currentUserId);
        swipe.setTargetId(targetId);
        swipe.setAction(SwipeAction.DISLIKE);
        swipeRepository.save(swipe);
    }

    @Transactional(readOnly = true)
    public List<MatchResponse> getMatches(UUID currentUserId) {
        checkAccess(currentUserId);

        List<Match> matches = matchRepository.findByUser1IdOrUser2Id(currentUserId, currentUserId);
        return matches.stream()
                .map(match -> {
                    UUID otherId = match.getUser1Id().equals(currentUserId) ? match.getUser2Id() : match.getUser1Id();
                    User other = userRepository.findById(otherId).orElse(null);
                    return mapToMatchResponse(match, other);
                })
                .collect(Collectors.toList());
    }

    private MatchResponse mapToMatchResponse(Match match, User other) {
        if (other == null)
            return null;
        return new MatchResponse(
                match.getId(),
                other.getId(),
                other.getUsername(),
                other.getFirstname(),
                other.getSubname(),
                other.getAvatar(),
                match.getMatchedAt());
    }

    private SwipeCandidateResponse mapToSwipeCandidateResponse(User user) {
        SwipeCandidateResponse dto = new SwipeCandidateResponse();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setFirstname(user.getFirstname());
        dto.setSubname(user.getSubname());
        dto.setAge(user.getAge());
        if (user.getRoles() != null) {
            Set<String> roles = user.getRoles().stream()
                    .map(Role::getRoleName)
                    .collect(Collectors.toSet());
            dto.setRoles(roles);
        }
        dto.setCity(user.getCity());
        dto.setAvatar(user.getAvatar());
        dto.setImages(user.getImages());
        dto.setPurposes(user.getPurposes());
        dto.setInterests(user.getInterests());
        dto.setDescription(user.getDescription());
        dto.setVerified(user.getVerified());
        return dto;
    }

    @Transactional(readOnly = true)
    public List<UserLikeResponse> getUsersWhoLikedMe(UUID currentUserId) {
        checkAccess(currentUserId);
        List<Swipe> likes = swipeRepository.findByTargetIdAndAction(currentUserId, SwipeAction.LIKE);
        return likes.stream()
                .map(swipe -> {
                    UUID swiperId = swipe.getSwiperId();
                    if (matchRepository.existsMatchBetweenUsers(currentUserId, swiperId)) {
                        return null;
                    }
                    User swiper = userRepository.findById(swiperId).orElse(null);
                    if (swiper == null)
                        return null;
                    return mapToUserLikeResponse(swiper);
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private UserLikeResponse mapToUserLikeResponse(User user) {
         UserLikeResponse dto = new UserLikeResponse();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setFirstname(user.getFirstname());
        dto.setSubname(user.getSubname());
        dto.setAge(user.getAge());
        dto.setAvatar(user.getAvatar());
        dto.setCity(user.getCity());
          if (user.getRoles() != null) {
            Set<String> roles = user.getRoles().stream()
                    .map(Role::getRoleName)
                    .collect(Collectors.toSet());
            dto.setRoles(roles);
        }
        dto.setFloor(user.getFloor());
        dto.setVerified(user.getVerified());

        return dto;
    }
}