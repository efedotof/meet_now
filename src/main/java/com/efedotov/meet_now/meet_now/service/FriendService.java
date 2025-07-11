package com.efedotov.meet_now.meet_now.service;

import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class FriendService {

    private final UserRepository userRepository;
    private final Map<UUID, Set<UUID>> friendRequests = new HashMap<>();

    public String sendFriendRequest(UUID fromUserId, UUID toUserId) {
        if (fromUserId.equals(toUserId)) return "Нельзя добавить самого себя";

        User fromUser = userRepository.findById(fromUserId)
                .orElseThrow(() -> new RuntimeException("Пользователь (отправитель) не найден"));
    

        if (fromUser.getFriends().contains(toUserId)) {
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

        currentUser.getFriends().add(requesterId);
        requester.getFriends().add(currentUserId);

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

        boolean removedFromUser = user.getFriends().remove(friendId);
        boolean removedFromFriend = friend.getFriends().remove(userId);

        userRepository.save(user);
        userRepository.save(friend);

        return (removedFromUser && removedFromFriend) ? "Пользователь удалён из друзей"
                : "Пользователь не был в списке друзей";
    }

    public List<User> getFriends(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        List<UUID> friendIds = user.getFriends();
        return userRepository.findAllById(friendIds);
    }

    public List<User> getIncomingRequests(UUID userId) {
        Set<UUID> requests = friendRequests.getOrDefault(userId, Collections.emptySet());
        return userRepository.findAllById(requests);
    }

    private void sendNotification(UUID userId, String message) {
        System.out.printf("Уведомление пользователю [%s]: %s%n", userId, message);
    }
}
