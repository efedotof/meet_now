package com.efedotov.meet_now.meet_now.controller.social;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.UserStatistics;
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.social.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/user")
@Tag(name = "User", description = "Эндпоинты для управления пользователями: получение профиля, обновление анкеты, управление приватностью")
@RequiredArgsConstructor
@EnableMethodSecurity
public class UserController {

    private final UserService userService;

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить всех пользователей", description = "Возвращает всех пользователей с пагинацией. Только для администраторов")
    @GetMapping("/admin/all")
    public ResponseEntity<Page<UserDto>> getAllUsers(
            Pageable pageable) {
        Page<UserDto> users = userService.getAllUsers(pageable);
        return ResponseEntity.ok(users);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить количество онлайн пользователей", description = "Возвращает количество пользователей онлайн. Только для администраторов")
    @GetMapping("/admin/statistics/online-count")
    public ResponseEntity<Long> getOnlineUsersCount() {
        long count = userService.getOnlineUsersCount();
        return ResponseEntity.ok(count);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить количество новых пользователей", description = "Возвращает количество новых пользователей за период. Только для администраторов")
    @GetMapping("/admin/statistics/new-users")
    public ResponseEntity<Long> getNewUsersCount(

            @RequestParam(defaultValue = "24") int hours) {
        long count = userService.getNewUsersCount(hours);
        return ResponseEntity.ok(count);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить активных пользователей", description = "Возвращает активных пользователей (были онлайн недавно). Только для администраторов")
    @GetMapping("/admin/active")
    public ResponseEntity<Page<UserDto>> getActiveUsers(
            Pageable pageable) {
        Page<UserDto> users = userService.getActiveUsers(pageable);
        return ResponseEntity.ok(users);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Удалить пользователя", description = "Полностью удаляет пользователя из системы. Только для администраторов")
    @DeleteMapping("/admin/{userId}")
    public ResponseEntity<Void> deleteUser(
            @PathVariable UUID userId) {
        userService.deleteUser(userId);
        return ResponseEntity.noContent().build();
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Заблокировать пользователя", description = "Блокирует пользователя. Только для администраторов")
    @PostMapping("/admin/{userId}/block")
    public ResponseEntity<Void> blockUser(@PathVariable UUID userId,
            @RequestParam(required = false, defaultValue = "Blocked by administrator") String reason) {
        userService.blockUser(userId, reason);
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Разблокировать пользователя", description = "Разблокирует пользователя. Только для администраторов")
    @PostMapping("/admin/{userId}/unblock")
    public ResponseEntity<Void> unblockUser(
            @PathVariable UUID userId) {
        userService.unblockUser(userId);
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Получить статистику пользователей", description = "Возвращает полную статистику по пользователям. Только для администраторов")
    @GetMapping("/admin/statistics/full")
    public ResponseEntity<UserStatistics> getUsersStatistics() {
        UserStatistics statistics = userService.getUsersStatistics();
        return ResponseEntity.ok(statistics);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Найти пользователей по email", description = "Поиск пользователей по email. Только для администраторов")
    @GetMapping("/admin/search/email")
    public ResponseEntity<Page<UserDto>> findUsersByEmail(
            @RequestParam String email,
            Pageable pageable) {
        Page<UserDto> users = userService.findUsersByEmail(email, pageable);
        return ResponseEntity.ok(users);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Найти пользователей по имени", description = "Поиск пользователей по имени пользователя. Только для администраторов")
    @GetMapping("/admin/search/username")
    public ResponseEntity<Page<UserDto>> findUsersByUsername(
            @RequestParam String username,
            Pageable pageable) {
        Page<UserDto> users = userService.findUsersByUsername(username, pageable);
        return ResponseEntity.ok(users);
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Добавить роль пользователю", description = "Добавляет роль пользователю. Только для администраторов")
    @PostMapping("/admin/{userId}/roles")
    public ResponseEntity<Void> addRoleToUser(
            @PathVariable UUID userId,
            @RequestParam String roleName) {
        userService.addRoleToUserAdministrationMethod(userId, roleName);
        return ResponseEntity.ok().build();
    }

    @AdminOnly
    @Operation(summary = "[АДМИНИСТРАТОР] Удалить роль у пользователя", description = "Удаляет роль у пользователя. Только для администраторов")
    @DeleteMapping("/admin/{userId}/roles")
    public ResponseEntity<Void> removeRoleFromUser(
            @PathVariable UUID userId,
            @RequestParam String roleName) {
        userService.removeRoleFromUser(userId, roleName);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Получение профиля по ID")
    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getProfile(@PathVariable UUID id) {
        return ResponseEntity.ok(mapToDto(userService.getById(id)));
    }

    @Operation(summary = "Обновление анкеты пользователя")
    @PutMapping("/{id}/profile")
    public ResponseEntity<UserDto> updateProfile(@PathVariable UUID id, @RequestBody UserDto userDto) {
        User updatedUser = userService.updateProfile(id, userDto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление описания пользователя")
    @PatchMapping("/{id}/description")
    public ResponseEntity<UserDto> updateDescription(@PathVariable UUID id, @RequestBody String description) {
        UserDto dto = new UserDto();
        dto.setDescription(description);
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление аватара пользователя")
    @PatchMapping("/{id}/avatar")
    public ResponseEntity<UserDto> updateAvatar(@PathVariable UUID id, @RequestBody String avatar) {
        UserDto dto = new UserDto();
        dto.setAvatar(avatar);
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @PatchMapping("/{id}/images")
    @Operation(summary = "Добавить изображения профиля")
    public ResponseEntity<UserDto> updateImages(@PathVariable UUID id, @RequestBody List<String> images) {
        UserDto dto = new UserDto();
        dto.setImages(images);
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление настройки isSearchable")
    @PatchMapping("/{id}/searchable")
    public ResponseEntity<Void> updateSearchable(@PathVariable UUID id, @RequestParam boolean isSearchable) {
        userService.updateSearchable(id, isSearchable);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Обновление целей пользователя")
    @PatchMapping("/{id}/purposes")
    public ResponseEntity<UserDto> updatePurposes(@PathVariable UUID id, @RequestBody UserDto dto) {
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление города пользователя")
    @PatchMapping("/{id}/city")
    public ResponseEntity<UserDto> updateCity(@PathVariable UUID id, @RequestBody String city) {
        UserDto dto = new UserDto();
        dto.setCity(city);
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление возраста пользователя")
    @PatchMapping("/{id}/age")
    public ResponseEntity<UserDto> updateAge(@PathVariable UUID id, @RequestBody Integer age) {
        UserDto dto = new UserDto();
        dto.setAge(age);
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление email пользователя")
    @PatchMapping("/{id}/email")
    public ResponseEntity<UserDto> updateEmail(@PathVariable UUID id, @RequestBody String email) {
        UserDto dto = new UserDto();
        dto.setEmail(email);
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление имени пользователя (username)")
    @PatchMapping("/{id}/username")
    public ResponseEntity<UserDto> updateUsername(@PathVariable UUID id, @RequestBody String username) {
        UserDto dto = new UserDto();
        dto.setUsername(username);
        User updatedUser = userService.updateProfile(id, dto);
        return ResponseEntity.ok(mapToDto(updatedUser));
    }

    @Operation(summary = "Обновление пароля пользователя")
    @PatchMapping("/{id}/password")
    public ResponseEntity<Void> updatePassword(
            @PathVariable UUID id,
            @RequestParam String oldPassword,
            @RequestParam String newPassword) {
        userService.updatePassword(id, oldPassword, newPassword);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Установка статуса онлайн/оффлайн пользователя")
    @PatchMapping("/{id}/online")
    public ResponseEntity<Void> updateOnlineStatus(
            @PathVariable UUID id,
            @RequestParam boolean isOnline) {
        userService.setUserOnline(id, isOnline);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Начало поиска")
    @PostMapping("/start-search")
    public void startSearch(Authentication authentication) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        userService.setUserSearching(userId, true);
    }

    @Operation(summary = "Стоп поиск")
    @PostMapping("/stop-search")
    public void stopSearch(Authentication authentication) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        userService.setUserSearching(userId, false);
    }

    @Operation(summary = "Включение/выключение карточного режима")
    @PatchMapping("/card-mode")
    public ResponseEntity<Void> updateCardMode(
            Authentication authentication,
            @RequestParam boolean enabled) {
        UUID userId = ((CustomUserDetails) authentication.getPrincipal()).getUserId();
        userService.updateCardMode(userId, enabled);
        return ResponseEntity.ok().build();
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