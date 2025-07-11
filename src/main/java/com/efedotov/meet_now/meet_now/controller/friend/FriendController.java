package com.efedotov.meet_now.meet_now.controller.friend;

import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.service.FriendService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/friend")
@Tag(name = "Friend", description = "Управление друзьями: отправка и подтверждение запросов в друзья, удаление из друзей, список друзей")
@RequiredArgsConstructor
public class FriendController {

    private final FriendService friendService;

    @PostMapping("/request/send")
    public ResponseEntity<String> sendFriendRequest(@RequestParam UUID fromUserId, @RequestParam UUID toUserId) {
        String result = friendService.sendFriendRequest(fromUserId, toUserId);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/request/accept")
    public ResponseEntity<String> acceptFriendRequest(@RequestParam UUID currentUserId, @RequestParam UUID requesterId) {
        String result = friendService.acceptFriendRequest(currentUserId, requesterId);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/request/reject")
    public ResponseEntity<String> rejectFriendRequest(@RequestParam UUID currentUserId, @RequestParam UUID requesterId) {
        String result = friendService.rejectFriendRequest(currentUserId, requesterId);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/remove")
    public ResponseEntity<String> removeFriend(@RequestParam UUID userId, @RequestParam UUID friendId) {
        String result = friendService.removeFriend(userId, friendId);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/list")
    public ResponseEntity<List<User>> getFriends(@RequestParam UUID userId) {
        Set<User> friendsSet = friendService.getFriends(userId);
        List<User> friendsList = friendsSet.stream().collect(Collectors.toList());
        return ResponseEntity.ok(friendsList);
    }

    @GetMapping("/requests/incoming")
    public ResponseEntity<List<User>> getIncomingRequests(@RequestParam UUID userId) {
        List<User> incoming = friendService.getIncomingRequests(userId);
        return ResponseEntity.ok(incoming);
    }
}
