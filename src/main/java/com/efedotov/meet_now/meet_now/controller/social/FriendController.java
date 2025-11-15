package com.efedotov.meet_now.meet_now.controller.social;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.dto.request.social.FriendAction;
import com.efedotov.meet_now.meet_now.dto.request.social.SendFriendRequest;
import com.efedotov.meet_now.meet_now.dto.request.social.RemoveFriendRequest;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendConnectionDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendRequestDto;
import com.efedotov.meet_now.meet_now.dto.response.social.FriendStatisticsDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserWithFriendCountDto;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.service.social.FriendService;

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

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить все дружеские связи", description = "Возвращает все дружеские связи между пользователями с пагинацией. Только для администраторов")
    @GetMapping("/admin/all-connections")
    public ResponseEntity<Page<FriendConnectionDto>> getAllFriendConnections(
            Pageable pageable) {
        Page<FriendConnectionDto> connections = friendService.getAllFriendConnections(pageable);
        return ResponseEntity.ok(connections);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить статистику друзей", description = "Возвращает статистику по дружеским связям. Только для администраторов")
    @GetMapping("/admin/statistics")
    public ResponseEntity<FriendStatisticsDto> getFriendStatistics() {
        FriendStatisticsDto statistics = friendService.getFriendStatistics();
        return ResponseEntity.ok(statistics);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить всех пользователей с количеством друзей", description = "Возвращает пользователей с количеством их друзей. Только для администраторов")
    @GetMapping("/admin/users-with-friend-count")
    public ResponseEntity<Page<UserWithFriendCountDto>> getUsersWithFriendCount(
            Pageable pageable) {
        Page<UserWithFriendCountDto> users = friendService.getUsersWithFriendCount(pageable);
        return ResponseEntity.ok(users);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить популярных пользователей", description = "Возвращает самых популярных пользователей (с наибольшим количеством друзей). Только для администраторов")
    @GetMapping("/admin/popular-users")
    public ResponseEntity<List<UserWithFriendCountDto>> getPopularUsers(
            @RequestParam(defaultValue = "10") int limit) {
        List<UserWithFriendCountDto> popularUsers = friendService.getPopularUsers(limit);
        return ResponseEntity.ok(popularUsers);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Удалить дружескую связь", description = "Принудительно удаляет дружескую связь между двумя пользователями. Только для администраторов")
    @DeleteMapping("/admin/remove-connection")
    public ResponseEntity<String> removeFriendConnection(
            @RequestParam UUID user1Id,
            @RequestParam UUID user2Id) {
        String result = friendService.removeFriendConnection(user1Id, user2Id);
        return ResponseEntity.ok(result);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить все активные запросы в друзья", description = "Возвращает все активные запросы в друзья. Только для администраторов")
    @GetMapping("/admin/all-active-requests")
    public ResponseEntity<List<FriendRequestDto>> getAllActiveFriendRequests() {
        List<FriendRequestDto> requests = friendService.getAllActiveFriendRequests();
        return ResponseEntity.ok(requests);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Удалить запрос в друзья", description = "Удаляет запрос в друзья. Только для администраторов")
    @DeleteMapping("/admin/remove-request")
    public ResponseEntity<String> removeFriendRequest(

            @RequestParam UUID fromUserId,
            @RequestParam UUID toUserId) {
        String result = friendService.removeFriendRequest(fromUserId, toUserId);
        return ResponseEntity.ok(result);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Очистить все запросы пользователя", description = "Очищает все исходящие и входящие запросы пользователя. Только для администраторов")
    @DeleteMapping("/admin/clear-user-requests")
    public ResponseEntity<String> clearUserFriendRequests(
            @RequestParam UUID userId) {
        String result = friendService.clearUserFriendRequests(userId);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/request/send")
    @Operation(summary = "Отправить запрос на добавление в друзья")
    public ResponseEntity<String> sendFriendRequest(@RequestBody SendFriendRequest request) {
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