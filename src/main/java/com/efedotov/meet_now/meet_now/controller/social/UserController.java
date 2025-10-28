package com.efedotov.meet_now.meet_now.controller.social;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
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
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
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