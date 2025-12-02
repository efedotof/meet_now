package com.efedotov.meet_now.meet_now.service.social;

import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.dto.response.social.FriendConnectionDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendRequestDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendsDistributionDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserWithFriendCountDto;
import com.efedotov.meet_now.meet_now.model.user.FriendRequest;
import com.efedotov.meet_now.meet_now.model.user.FriendRequestStatus;
import com.efedotov.meet_now.meet_now.model.user.Friendship;
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.FriendRequestRepository;
import com.efedotov.meet_now.meet_now.repository.user.FriendshipRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.notification.InternalNotificationService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class FriendService {

    private final UserRepository userRepository;
    private final FriendRequestRepository friendRequestRepository;
    private final FriendshipRepository friendshipRepository;
    private final InternalNotificationService internalNotificationService;

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<FriendConnectionDto> getAllFriendConnections(Pageable pageable) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        List<Friendship> allFriendships = friendshipRepository.findAll();
        List<FriendConnectionDto> allConnections = allFriendships.stream()
                .map(friendship -> {
                    FriendConnectionDto connection = new FriendConnectionDto();
                    connection.setUser1Id(friendship.getUser().getId());
                    connection.setUser1Username(friendship.getUser().getUsername());
                    connection.setUser2Id(friendship.getFriend().getId());
                    connection.setUser2Username(friendship.getFriend().getUsername());
                    connection.setFriendsSince(friendship.getFriendsSince());
                    return connection;
                })
                .collect(Collectors.toList());

        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), allConnections.size());
        List<FriendConnectionDto> pageContent = allConnections.subList(start, end);

        return new PageImpl<>(pageContent, pageable, allConnections.size());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public FriendStatisticsDto getFriendStatistics() {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        FriendStatisticsDto statistics = new FriendStatisticsDto();

        long totalUsers = userRepository.count();
        long totalFriendships = friendshipRepository.count();
        long pendingRequestsCount = friendRequestRepository.countPendingRequests();

        statistics.setTotalUsers(totalUsers);
        statistics.setTotalFriendships(totalFriendships / 2);

        Double avgFriends = friendshipRepository.getAverageFriendsPerUser();
        statistics.setAverageFriendsPerUser(avgFriends != null ? avgFriends : 0.0);

        Integer maxFriends = friendshipRepository.getMaxFriendsCount();
        statistics.setMostFriendsCount(maxFriends != null ? maxFriends : 0);

        long usersWithNoFriends = userRepository.count() - userRepository.countUsersWithFriends();
        statistics.setUsersWithNoFriends(usersWithNoFriends);

        statistics.setFriendRequestsCount(pendingRequestsCount);
        statistics.setFriendsDistribution(calculateFriendsDistribution());

        return statistics;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<UserWithFriendCountDto> getUsersWithFriendCount(Pageable pageable) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        Page<User> usersPage = userRepository.findAll(pageable);

        List<UserWithFriendCountDto> usersWithFriendCount = usersPage.getContent().stream()
                .map(user -> {
                    UserWithFriendCountDto dto = new UserWithFriendCountDto();
                    dto.setUserId(user.getId());
                    dto.setUsername(user.getUsername());
                    dto.setEmail(user.getEmail());

                    long friendCount = friendshipRepository.countByUserId(user.getId());
                    dto.setFriendCount((int) friendCount);

                    dto.setCreatedAt(user.getCreatedAt());
                    return dto;
                })
                .collect(Collectors.toList());

        return new PageImpl<>(usersWithFriendCount, pageable, usersPage.getTotalElements());
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<UserWithFriendCountDto> getPopularUsers(int limit) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        List<Object[]> popularUsersData = userRepository.findPopularUsersWithFriendCount(limit);

        return popularUsersData.stream()
                .map(data -> {
                    User user = (User) data[0];
                    Long friendCount = (Long) data[1];

                    UserWithFriendCountDto dto = new UserWithFriendCountDto();
                    dto.setUserId(user.getId());
                    dto.setUsername(user.getUsername());
                    dto.setEmail(user.getEmail());
                    dto.setFriendCount(friendCount.intValue());
                    dto.setCreatedAt(user.getCreatedAt());
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional
    public String removeFriendConnection(UUID user1Id, UUID user2Id) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        friendshipRepository.deleteByUserIdAndFriendId(user1Id, user2Id);
        friendshipRepository.deleteByUserIdAndFriendId(user2Id, user1Id);

        log.info("Администратор {} удалил дружескую связь между {} и {}", adminId, user1Id, user2Id);
        return "Дружеская связь удалена";
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<FriendRequestDto> getAllActiveFriendRequests() {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        List<FriendRequest> requests = friendRequestRepository.findByStatus(FriendRequestStatus.PENDING);

        return requests.stream()
                .map(request -> {
                    FriendRequestDto dto = new FriendRequestDto();
                    dto.setFromUserId(request.getFromUser().getId());
                    dto.setFromUsername(request.getFromUser().getUsername());
                    dto.setToUserId(request.getToUser().getId());
                    dto.setToUsername(request.getToUser().getUsername());
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @AdminOnly
    @Transactional
    public String removeFriendRequest(UUID fromUserId, UUID toUserId) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        Optional<FriendRequest> friendRequest = friendRequestRepository
                .findByFromUserIdAndToUserIdAndStatus(fromUserId, toUserId, FriendRequestStatus.PENDING);

        if (friendRequest.isPresent()) {
            friendRequestRepository.delete(friendRequest.get());
            log.info("Администратор {} удалил запрос в друзья от {} к {}", adminId, fromUserId, toUserId);
            return "Запрос в друзья удален";
        } else {
            return "Запрос в друзья не найден";
        }
    }

    @AdminOnly
    @Transactional
    public String clearUserFriendRequests(UUID userId) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        List<FriendRequest> incomingRequests = friendRequestRepository
                .findByToUserIdAndStatus(userId, FriendRequestStatus.PENDING);

        List<FriendRequest> outgoingRequests = friendRequestRepository
                .findByFromUserIdAndStatus(userId, FriendRequestStatus.PENDING);

        int totalRemoved = incomingRequests.size() + outgoingRequests.size();

        friendRequestRepository.deleteAll(incomingRequests);
        friendRequestRepository.deleteAll(outgoingRequests);

        log.info("Администратор {} очистил {} запросов пользователя {}", adminId, totalRemoved, userId);
        return String.format("Удалено %d запросов пользователя", totalRemoved);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private void validateAdmin(UUID userId) {
        if (!userRepository.hasModerationRole(userId)) {
            throw new RuntimeException("User does not have administrator rights");
        }
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private FriendsDistributionDto calculateFriendsDistribution() {
        long totalUsers = userRepository.count();

        long zeroFriends = totalUsers - userRepository.countUsersWithFriends();
        long oneToFiveFriends = userRepository.countUsersWithFriendsBetween(1, 5);
        long sixToTenFriends = userRepository.countUsersWithFriendsBetween(6, 10);
        long elevenToTwentyFriends = userRepository.countUsersWithFriendsBetween(11, 20);
        long twentyOnePlusFriends = userRepository.countUsersWithFriendsMoreThan(20);

        return FriendsDistributionDto.builder()
                .zeroFriends(zeroFriends)
                .oneToFiveFriends(oneToFiveFriends)
                .sixToTenFriends(sixToTenFriends)
                .elevenToTwentyFriends(elevenToTwentyFriends)
                .twentyOnePlusFriends(twentyOnePlusFriends)
                .build();
    }

    @Transactional
    public String sendFriendRequest(UUID fromUserId, UUID toUserId) {
        if (fromUserId.equals(toUserId))
            return "Нельзя добавить самого себя";

        User fromUser = userRepository.findById(fromUserId)
                .orElseThrow(() -> new RuntimeException("Пользователь (отправитель) не найден"));

        User toUser = userRepository.findById(toUserId)
                .orElseThrow(() -> new RuntimeException("Пользователь (получатель) не найден"));

        if (friendshipRepository.existsByUserIdAndFriendId(fromUserId, toUserId)) {
            return "Пользователь уже в списке друзей";
        }

        if (friendRequestRepository.existsByFromUserIdAndToUserIdAndStatus(
                fromUserId, toUserId, FriendRequestStatus.PENDING)) {
            return "Запрос уже был отправлен ранее";
        }

        FriendRequest friendRequest = new FriendRequest();
        friendRequest.setFromUser(fromUser);
        friendRequest.setToUser(toUser);
        friendRequest.setStatus(FriendRequestStatus.PENDING);

        friendRequestRepository.save(friendRequest);

        try {
            internalNotificationService.sendFriendRequestNotification(
                    toUser.getId(), fromUser.getId(), fromUser.getUsername());
        } catch (Exception e) {
        }

        return "Запрос в друзья отправлен";
    }

    @Transactional
    public String acceptFriendRequest(UUID currentUserId, UUID requesterId) {
        FriendRequest friendRequest = friendRequestRepository
                .findByFromUserIdAndToUserIdAndStatus(requesterId, currentUserId, FriendRequestStatus.PENDING)
                .orElseThrow(() -> new RuntimeException("Запрос в друзья не найден"));

        User currentUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        User requester = userRepository.findById(requesterId)
                .orElseThrow(() -> new RuntimeException("Пользователь (отправитель) не найден"));

        Friendship friendship1 = new Friendship();
        friendship1.setUser(currentUser);
        friendship1.setFriend(requester);

        Friendship friendship2 = new Friendship();
        friendship2.setUser(requester);
        friendship2.setFriend(currentUser);

        friendshipRepository.save(friendship1);
        friendshipRepository.save(friendship2);

        friendRequest.setStatus(FriendRequestStatus.ACCEPTED);
        friendRequestRepository.save(friendRequest);

        sendNotification(requesterId, currentUser.getUsername() + " принял ваш запрос в друзья");

        return "Запрос в друзья принят";
    }

    @Transactional
    public String rejectFriendRequest(UUID currentUserId, UUID requesterId) {
        FriendRequest friendRequest = friendRequestRepository
                .findByFromUserIdAndToUserIdAndStatus(requesterId, currentUserId, FriendRequestStatus.PENDING)
                .orElseThrow(() -> new RuntimeException("Запрос в друзья не найден"));

        friendRequest.setStatus(FriendRequestStatus.REJECTED);
        friendRequestRepository.save(friendRequest);

        return "Запрос отклонён";
    }

    @Transactional
    public String removeFriend(UUID userId, UUID friendId) {
        friendshipRepository.deleteByUserIdAndFriendId(userId, friendId);
        friendshipRepository.deleteByUserIdAndFriendId(friendId, userId);

        return "Пользователь удалён из друзей";
    }

    @Transactional(readOnly = true)
    public List<FriendDto> getFriends(UUID userId) {
        List<Friendship> friendships = friendshipRepository.findByUserId(userId);
        return friendships.stream()
                .map(Friendship::getFriend)
                .map(this::mapToFriendDto)
                .collect(Collectors.toList());
    }

    private FriendDto mapToFriendDto(User user) {
        FriendDto dto = new FriendDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFirstname(user.getFirstname());
        dto.setSubname(user.getSubname());
        dto.setDescription(user.getDescription());
        dto.setAvatar(user.getAvatar());
        dto.setCity(user.getCity());
        dto.setAge(user.getAge());
        dto.setCreatedAt(user.getCreatedAt());
        dto.setVerified(user.getVerified());
        dto.setIsOnline(user.getIsOnline());
        dto.setFloor(user.getFloor());
        dto.setGamePoints(user.getGamePoints());
        dto.setImages(user.getImages());
        return dto;
    }

    @Transactional(readOnly = true)
    public List<UserDto> getIncomingRequests(UUID userId) {
        List<FriendRequest> requests = friendRequestRepository
                .findByToUserIdAndStatus(userId, FriendRequestStatus.PENDING);

        return requests.stream()
                .map(FriendRequest::getFromUser)
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    private void sendNotification(UUID userId, String message) {
        System.out.printf("Уведомление пользователю [%s]: %s%n", userId, message);
    }

    private UserDto mapToDto(User user) {
        UserDto dto = new UserDto();
        BeanUtils.copyProperties(user, dto);

        if (user.getRoles() != null) {
            Set<String> roles = user.getRoles().stream()
                    .map(Role::getRoleName)
                    .collect(Collectors.toSet());
            dto.setRoles(roles);
        }
        return dto;
    }

    private UUID getCurrentAdminId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            return ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        } else {
            return null;
        }
    }
}