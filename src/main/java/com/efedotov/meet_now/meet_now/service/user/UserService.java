package com.efedotov.meet_now.meet_now.service.user;

import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.model.Role;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.RoleRepository;
import com.efedotov.meet_now.meet_now.repository.UserRepository;
import com.efedotov.meet_now.meet_now.until.EncryptionUtils;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final EncryptionUtils encryptionUtils;
    private final RoleRepository roleRepository;

    public User getById(UUID id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Transactional
    public User updateProfile(UUID userId, UserDto dto) {
        User user = getById(userId);

        if (dto.getUsername() != null && !dto.getUsername().equals(user.getUsername())) {
            userRepository.findByUsername(dto.getUsername()).ifPresent(u -> {
                if (!u.getId().equals(userId)) {
                    throw new RuntimeException("Username already taken");
                }
            });
            user.setUsername(dto.getUsername());
        }

        if (dto.getEmail() != null && !dto.getEmail().equals(user.getEmail())) {
            userRepository.findByEmail(dto.getEmail()).ifPresent(u -> {
                if (!u.getId().equals(userId)) {
                    throw new RuntimeException("Email already registered");
                }
            });
            user.setEmail(dto.getEmail());
        }

        if (dto.getFirstname() != null)
            user.setFirstname(dto.getFirstname());
        if (dto.getSubname() != null)
            user.setSubname(dto.getSubname());
        if (dto.getDescription() != null)
            user.setDescription(dto.getDescription());
        if (dto.getAvatar() != null)
            user.setAvatar(dto.getAvatar());
        if (dto.getCity() != null)
            user.setCity(dto.getCity());
        if (dto.getAge() != null)
            user.setAge(dto.getAge());
        if (dto.getPurposes() != null)
            user.setPurposes(dto.getPurposes());
        if (dto.getInterests() != null)
            user.setInterests(dto.getInterests());
        if (dto.getIsSearchable() != null)
            user.setIsSearchable(dto.getIsSearchable());

        return userRepository.save(user);
    }

    // Обновление пароля
    public void updatePassword(UUID userId, String oldPassword, String newPassword) {
        User user = getById(userId);
        String oldPasswordHash = encryptionUtils.hashPassword(oldPassword);
        if (!user.getPassword().equals(oldPasswordHash)) {
            throw new RuntimeException("Old password is incorrect");
        }

        user.setPassword(oldPasswordHash);
        userRepository.save(user);
    }

    public void updateSearchable(UUID userId, boolean isSearchable) {
        User user = getById(userId);
        user.setIsSearchable(isSearchable);
        userRepository.save(user);
    }

    @Transactional
    public void addRoleToUser(UUID userId, String roleName) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Role role = roleRepository.findByRoleName(roleName)
                .orElseThrow(() -> new RuntimeException("Role not found"));

        user.getRoles().add(role);
        userRepository.save(user);
    }

    @Transactional
    public void setUserOnline(UUID userId, boolean isOnline) {
        User user = getById(userId);
        if (user.getIsOnline() != isOnline) {
            user.setIsOnline(isOnline);
            userRepository.save(user);
            log.info("Статус онлайн пользователя {} изменен на: {}", userId, isOnline);
        } else {
            log.debug("Статус онлайн пользователя {} уже установлен в: {}", userId, isOnline);
        }
    }

    public void setUserSearching(UUID userId, boolean isSearching) {
    User user = getById(userId);
    user.setIsSearching(isSearching);
    userRepository.save(user);
}


}   
