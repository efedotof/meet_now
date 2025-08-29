package com.efedotov.meet_now.meet_now.controller.user;

import java.util.List;
import java.util.UUID;

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

import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.user.UserService;

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
    public ResponseEntity<User> getProfile(@PathVariable UUID id) {
        return ResponseEntity.ok(userService.getById(id));
    }

    @Operation(summary = "Обновление анкеты пользователя")
    @PutMapping("/{id}/profile")
    public ResponseEntity<User> updateProfile(@PathVariable UUID id, @RequestBody UserDto userDto) {
        return ResponseEntity.ok(userService.updateProfile(id, userDto));
    }

    @Operation(summary = "Обновление описания пользователя")
    @PatchMapping("/{id}/description")
    public ResponseEntity<User> updateDescription(@PathVariable UUID id, @RequestBody String description) {
        UserDto dto = new UserDto();
        dto.setDescription(description);
        return ResponseEntity.ok(userService.updateProfile(id, dto));
    }

    @Operation(summary = "Обновление аватара пользователя")
    @PatchMapping("/{id}/avatar")
    public ResponseEntity<User> updateAvatar(@PathVariable UUID id, @RequestBody String avatar) {
        UserDto dto = new UserDto();
        dto.setAvatar(avatar);
        return ResponseEntity.ok(userService.updateProfile(id, dto));
    }

    @PatchMapping("/{id}/images")
    @Operation(summary = "Добавить изображения профиля")
    public ResponseEntity<User> updateImages(@PathVariable UUID id, @RequestBody List<String> images) {
        UserDto dto = new UserDto();
        dto.setImages(images);
        return ResponseEntity.ok(userService.updateProfile(id, dto));
    }

    @Operation(summary = "Обновление настройки isSearchable")
    @PatchMapping("/{id}/searchable")
    public ResponseEntity<Void> updateSearchable(@PathVariable UUID id, @RequestParam boolean isSearchable) {
        userService.updateSearchable(id, isSearchable);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Обновление целей пользователя")
    @PatchMapping("/{id}/purposes")
    public ResponseEntity<User> updatePurposes(@PathVariable UUID id, @RequestBody UserDto dto) {
        return ResponseEntity.ok(userService.updateProfile(id, dto));
    }

    @Operation(summary = "Обновление города пользователя")
    @PatchMapping("/{id}/city")
    public ResponseEntity<User> updateCity(@PathVariable UUID id, @RequestBody String city) {
        UserDto dto = new UserDto();
        dto.setCity(city);
        return ResponseEntity.ok(userService.updateProfile(id, dto));
    }

    @Operation(summary = "Обновление возраста пользователя")
    @PatchMapping("/{id}/age")
    public ResponseEntity<User> updateAge(@PathVariable UUID id, @RequestBody Integer age) {
        UserDto dto = new UserDto();
        dto.setAge(age);
        return ResponseEntity.ok(userService.updateProfile(id, dto));
    }

    @Operation(summary = "Обновление email пользователя")
    @PatchMapping("/{id}/email")
    public ResponseEntity<User> updateEmail(@PathVariable UUID id, @RequestBody String email) {
        UserDto dto = new UserDto();
        dto.setEmail(email);
        return ResponseEntity.ok(userService.updateProfile(id, dto));
    }

    @Operation(summary = "Обновление имени пользователя (username)")
    @PatchMapping("/{id}/username")
    public ResponseEntity<User> updateUsername(@PathVariable UUID id, @RequestBody String username) {
        UserDto dto = new UserDto();
        dto.setUsername(username);
        return ResponseEntity.ok(userService.updateProfile(id, dto));
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

}
