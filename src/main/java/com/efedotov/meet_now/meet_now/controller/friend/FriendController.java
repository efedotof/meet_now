package com.efedotov.meet_now.meet_now.controller.friend;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.dto.request.FriendAction;
import com.efedotov.meet_now.meet_now.dto.request.FriendRequest;
import com.efedotov.meet_now.meet_now.dto.request.RemoveFriendRequest;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.service.user.FriendService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/friend")
@Tag(name = "Friend", description = "Управление друзьями: отправка и подтверждение запросов в друзья, удаление из друзей, список друзей")
@RequiredArgsConstructor
@EnableMethodSecurity
public class FriendController {

    private final FriendService friendService;

    @PostMapping("/request/send")
     @Operation(summary = "Отправить запрос на добавление в друзья")
    public ResponseEntity<String> sendFriendRequest(@RequestBody FriendRequest request) {
        String result = friendService.sendFriendRequest(request.getFromUserId(), request.getToUserId());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/request/accept")
     @Operation(summary = "Принять предложение в друзья")
    public ResponseEntity<String> acceptFriendRequest(@RequestBody FriendAction request) {
        String result = friendService.acceptFriendRequest(request.getCurrentUserId(), request.getRequesterId());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/request/reject")
     @Operation(summary = "Отклонить предложение")
    public ResponseEntity<String> rejectFriendRequest(@RequestBody FriendAction request) {
        String result = friendService.rejectFriendRequest(request.getCurrentUserId(), request.getRequesterId());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/remove")
     @Operation(summary = "Удалить друга")
    public ResponseEntity<String> removeFriend(@RequestBody RemoveFriendRequest request) {
        String result = friendService.removeFriend(request.getUserId(), request.getFriendId());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/list")
     @Operation(summary = "Получить список друзей пользователя")
    public ResponseEntity<List<User>> getFriends(@RequestParam UUID userId) {
        Set<User> friendsSet = friendService.getFriends(userId);
        List<User> friendsList = friendsSet.stream().collect(Collectors.toList());
        return ResponseEntity.ok(friendsList);
    }

    @GetMapping("/requests/incoming")
     @Operation(summary = "Получить список на дружбу")
    public ResponseEntity<List<UserDto>> getIncomingRequests(@RequestParam UUID userId) {
        List<UserDto> incoming = friendService.getIncomingRequests(userId);
        return ResponseEntity.ok(incoming);
    }
}