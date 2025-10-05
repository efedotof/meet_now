package com.efedotov.meet_now.meet_now.service.social;

import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FriendService {

    private final UserRepository userRepository;
    private final Map<UUID, Set<UUID>> friendRequests = new HashMap<>();

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

    public String acceptFriendRequest(UUID currentUserId, UUID requesterId) {
        Set<UUID> requests = friendRequests.getOrDefault(currentUserId, new HashSet<>());
        if (!requests.contains(requesterId)) {
            return "Нет запроса от данного пользователя";
        }

        User currentUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        User requester = userRepository.findById(requesterId)
                .orElseThrow(() -> new RuntimeException("Пользователь (отправитель) не найден"));

        // Добавляем друг друга в сет друзей
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

    public Set<User> getFriends(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        return user.getFriends();
    }

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
}
