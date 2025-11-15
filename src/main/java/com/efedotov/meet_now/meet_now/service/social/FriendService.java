package com.efedotov.meet_now.meet_now.service.social;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendConnectionDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendRequestDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendsDistributionDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserWithFriendCountDto;
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class FriendService {

    private final UserRepository userRepository;
    private final Map<UUID, Set<UUID>> friendRequests = new HashMap<>();

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<FriendConnectionDto> getAllFriendConnections(Pageable pageable) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        List<FriendConnectionDto> allConnections = new ArrayList<>();

        List<User> allUsers = userRepository.findAll();
        for (User user : allUsers) {
            for (User friend : user.getFriends()) {
                FriendConnectionDto connection = new FriendConnectionDto();
                connection.setUser1Id(user.getId());
                connection.setUser1Username(user.getUsername());
                connection.setUser2Id(friend.getId());
                connection.setUser2Username(friend.getUsername());
                connection.setFriendsSince(user.getCreatedAt());
                allConnections.add(connection);
            }
        }

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

        List<User> allUsers = userRepository.findAll();

        statistics.setTotalUsers(allUsers.size());
        statistics.setTotalFriendships(countTotalFriendships());
        statistics.setAverageFriendsPerUser(calculateAverageFriendsPerUser(allUsers));
        statistics.setUsersWithNoFriends(countUsersWithNoFriends(allUsers));
        statistics.setMostFriendsCount(findMostFriendsCount(allUsers));
        statistics.setFriendRequestsCount(friendRequests.values().stream().mapToInt(Set::size).sum());
        statistics.setFriendsDistribution(calculateFriendsDistribution(allUsers));

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
                    dto.setFriendCount(user.getFriends().size());
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

        List<User> allUsers = userRepository.findAll();

        return allUsers.stream()
                .sorted((u1, u2) -> Integer.compare(u2.getFriends().size(), u1.getFriends().size()))
                .limit(limit)
                .map(user -> {
                    UserWithFriendCountDto dto = new UserWithFriendCountDto();
                    dto.setUserId(user.getId());
                    dto.setUsername(user.getUsername());
                    dto.setEmail(user.getEmail());
                    dto.setFriendCount(user.getFriends().size());
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

        User user1 = userRepository.findById(user1Id)
                .orElseThrow(() -> new RuntimeException("Пользователь 1 не найден"));
        User user2 = userRepository.findById(user2Id)
                .orElseThrow(() -> new RuntimeException("Пользователь 2 не найден"));

        boolean removedFromUser1 = user1.getFriends().remove(user2);
        boolean removedFromUser2 = user2.getFriends().remove(user1);

        if (removedFromUser1 || removedFromUser2) {
            userRepository.save(user1);
            userRepository.save(user2);
            log.info("Администратор {} удалил дружескую связь между {} и {}", adminId, user1Id, user2Id);
            return "Дружеская связь удалена";
        } else {
            return "Дружеская связь не найдена";
        }
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public List<FriendRequestDto> getAllActiveFriendRequests() {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        List<FriendRequestDto> allRequests = new ArrayList<>();

        for (Map.Entry<UUID, Set<UUID>> entry : friendRequests.entrySet()) {
            UUID toUserId = entry.getKey();
            User toUser = userRepository.findById(toUserId).orElse(null);

            for (UUID fromUserId : entry.getValue()) {
                User fromUser = userRepository.findById(fromUserId).orElse(null);

                if (toUser != null && fromUser != null) {
                    FriendRequestDto request = new FriendRequestDto();
                    request.setFromUserId(fromUserId);
                    request.setFromUsername(fromUser.getUsername());
                    request.setToUserId(toUserId);
                    request.setToUsername(toUser.getUsername());
                    allRequests.add(request);
                }
            }
        }

        return allRequests;
    }

    @AdminOnly
    @Transactional
    public String removeFriendRequest(UUID fromUserId, UUID toUserId) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        Set<UUID> requests = friendRequests.get(toUserId);
        if (requests != null && requests.contains(fromUserId)) {
            requests.remove(fromUserId);
            if (requests.isEmpty()) {
                friendRequests.remove(toUserId);
            }
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

        int removedCount = 0;

        Set<UUID> incomingRequests = friendRequests.remove(userId);
        if (incomingRequests != null) {
            removedCount += incomingRequests.size();
        }

        Iterator<Map.Entry<UUID, Set<UUID>>> iterator = friendRequests.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<UUID, Set<UUID>> entry = iterator.next();
            if (entry.getValue().remove(userId)) {
                removedCount++;
                if (entry.getValue().isEmpty()) {
                    iterator.remove();
                }
            }
        }

        log.info("Администратор {} очистил {} запросов пользователя {}", adminId, removedCount, userId);
        return String.format("Удалено %d запросов пользователя", removedCount);
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
    private long countTotalFriendships() {
        return userRepository.findAll().stream()
                .mapToLong(user -> user.getFriends().size())
                .sum() / 2;
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private double calculateAverageFriendsPerUser(List<User> users) {
        if (users.isEmpty())
            return 0.0;
        return users.stream()
                .mapToInt(user -> user.getFriends().size())
                .average()
                .orElse(0.0);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private long countUsersWithNoFriends(List<User> users) {
        return users.stream()
                .filter(user -> user.getFriends().isEmpty())
                .count();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private int findMostFriendsCount(List<User> users) {
        return users.stream()
                .mapToInt(user -> user.getFriends().size())
                .max()
                .orElse(0);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private FriendsDistributionDto calculateFriendsDistribution(List<User> users) {
        long zeroFriends = users.stream().filter(u -> u.getFriends().isEmpty()).count();
        long oneToFiveFriends = users.stream().filter(u -> u.getFriends().size() >= 1 && u.getFriends().size() <= 5)
                .count();
        long sixToTenFriends = users.stream().filter(u -> u.getFriends().size() >= 6 && u.getFriends().size() <= 10)
                .count();
        long elevenToTwentyFriends = users.stream()
                .filter(u -> u.getFriends().size() >= 11 && u.getFriends().size() <= 20).count();
        long twentyOnePlusFriends = users.stream().filter(u -> u.getFriends().size() > 20).count();

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

        if (fromUser.getFriends().contains(toUser)) {
            return "Пользователь уже в списке друзей";
        }

        friendRequests.putIfAbsent(toUserId, new HashSet<>());
        boolean added = friendRequests.get(toUserId).add(fromUserId);

        return added ? "Запрос в друзья отправлен" : "Запрос уже был отправлен ранее";
    }

    @Transactional
    public String acceptFriendRequest(UUID currentUserId, UUID requesterId) {
        Set<UUID> requests = friendRequests.getOrDefault(currentUserId, new HashSet<>());
        if (!requests.contains(requesterId)) {
            return "Нет запроса от данного пользователя";
        }

        User currentUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        User requester = userRepository.findById(requesterId)
                .orElseThrow(() -> new RuntimeException("Пользователь (отправитель) не найден"));

        currentUser.getFriends().add(requester);
        requester.getFriends().add(currentUser);

        userRepository.save(currentUser);
        userRepository.save(requester);

        requests.remove(requesterId);
        if (requests.isEmpty()) {
            friendRequests.remove(currentUserId);
        }

        sendNotification(requesterId, currentUser.getUsername() + " принял ваш запрос в друзья");

        return "Запрос в друзья принят";
    }

    @Transactional
    public String rejectFriendRequest(UUID currentUserId, UUID requesterId) {
        Set<UUID> requests = friendRequests.getOrDefault(currentUserId, new HashSet<>());
        if (!requests.contains(requesterId)) {
            return "Нет запроса от данного пользователя";
        }

        requests.remove(requesterId);
        if (requests.isEmpty()) {
            friendRequests.remove(currentUserId);
        }

        return "Запрос отклонён";
    }

    @Transactional
    public String removeFriend(UUID userId, UUID friendId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        User friend = userRepository.findById(friendId)
                .orElseThrow(() -> new RuntimeException("Друг не найден"));

        boolean removedFromUser = user.getFriends().remove(friend);
        boolean removedFromFriend = friend.getFriends().remove(user);

        userRepository.save(user);
        userRepository.save(friend);

        return (removedFromUser && removedFromFriend) ? "Пользователь удалён из друзей"
                : "Пользователь не был в списке друзей";
    }

    @Transactional(readOnly = true)
    public Set<User> getFriends(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        return user.getFriends();
    }

    @Transactional(readOnly = true)
    public List<UserDto> getIncomingRequests(UUID userId) {
        Set<UUID> requests = friendRequests.getOrDefault(userId, Collections.emptySet());

        List<User> users = userRepository.findAllById(requests);

        return users.stream().map(this::mapToDto).collect(Collectors.toList());
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