package com.efedotov.meet_now.meet_now.service.social;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.dto.response.statistics.UserStatistics;
import com.efedotov.meet_now.meet_now.model.user.Role;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.moderation.RoleRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.service.util.EncryptionUtils;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final EncryptionUtils encryptionUtils;
    private final RoleRepository roleRepository;
    private final StatisticsService statisticsService;

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<UserDto> getAllUsers(Pageable pageable) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        return userRepository.findAll(pageable)
                .map(this::mapToDto);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public long getOnlineUsersCount() {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);
        return userRepository.countByIsOnlineTrue();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public long getNewUsersCount(int hours) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);
        LocalDateTime since = LocalDateTime.now().minusHours(hours);
        return userRepository.countByCreatedAtAfter(since);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<UserDto> getActiveUsers(Pageable pageable) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        return userRepository.findByIsOnlineTrue(pageable)
                .map(this::mapToDto);
    }

    @AdminOnly
    @Transactional
    public void deleteUser(UUID userId) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (adminId.equals(userId)) {
            throw new RuntimeException("Cannot delete yourself");
        }

        userRepository.delete(user);
        log.info("User {} deleted by admin {}", userId, adminId);
    }

    @AdminOnly
    @Transactional
    public void blockUser(UUID userId) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        addRoleToUserAdministrationMethod(userId, "BLOCKED");
        user.setIsSearchable(false);
        user.setIsOnline(false);
        user.setIsSearching(false);

        userRepository.save(user);
        log.info("User {} blocked by admin {}", userId, adminId);
    }

    @AdminOnly
    @Transactional
    public void unblockUser(UUID userId) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        removeRoleFromUser(userId, "BLOCKED");
        user.setIsSearchable(true);

        userRepository.save(user);
        log.info("User {} unblocked by admin {}", userId, adminId);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public UserStatistics getUsersStatistics() {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        return UserStatistics.builder()
                .totalUsers(userRepository.count())
                .onlineUsers(userRepository.countByIsOnlineTrue())
                .searchableUsers(userRepository.countByIsSearchableTrue())
                .searchingUsers(userRepository.countByIsSearchingTrue())
                .newUsersLast24h(userRepository.countByCreatedAtAfter(LocalDateTime.now().minusHours(24)))
                .newUsersLast7d(userRepository.countByCreatedAtAfter(LocalDateTime.now().minusDays(7)))
                .usersByCity(userRepository.countUsersByCity())
                .build();
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<UserDto> findUsersByEmail(String email, Pageable pageable) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        return userRepository.findByEmailContainingIgnoreCase(email, pageable)
                .map(this::mapToDto);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    public Page<UserDto> findUsersByUsername(String username, Pageable pageable) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        return userRepository.findByUsernameContainingIgnoreCase(username, pageable)
                .map(this::mapToDto);
    }

    @AdminOnly
    @Transactional
    public void addRoleToUserAdministrationMethod(UUID userId, String roleName) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Role role = roleRepository.findByRoleName(roleName)
                .orElseThrow(() -> new RuntimeException("Role not found"));

        user.getRoles().add(role);
        userRepository.save(user);
        log.info("Role {} added to user {} by admin {}", roleName, userId, adminId);
    }

    @AdminOnly
    @Transactional
    public void removeRoleFromUser(UUID userId, String roleName) {
        UUID adminId = getCurrentAdminId();
        validateAdmin(adminId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Role role = roleRepository.findByRoleName(roleName)
                .orElseThrow(() -> new RuntimeException("Role not found"));

        user.getRoles().remove(role);
        userRepository.save(user);
        log.info("Role {} removed from user {} by admin {}", roleName, userId, adminId);
    }

    @AdminOnly
    @Transactional(readOnly = true)
    private void validateAdmin(UUID userId) {
        if (!userRepository.hasModerationRole(userId)) {
            throw new RuntimeException("User does not have administrator rights");
        }
    }

    @Transactional(readOnly = true)
    public boolean hasModerationRole(UUID userId) {
        return userRepository.hasModerationRole(userId);
    }

    @Transactional(readOnly = true)
    public User getById(UUID id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Transactional(readOnly = true)
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Transactional
    public boolean tryLockUserForSearch(UUID userId) {
        try {
            int updated = userRepository.setUserSearchingStatus(userId, false, false);
            if (updated > 0) {
                statisticsService.refreshAndBroadcastStats();
            }
            return updated > 0;
        } catch (Exception e) {
            log.error("Ошибка при блокировке пользователя для поиска: {}", userId, e);
            return false;
        }
    }

    @Transactional
    public void unlockUserForSearch(UUID userId) {
        try {
            int updated = userRepository.setUserSearchingStatus(userId, true, false);
            if (updated > 0) {
                statisticsService.refreshAndBroadcastStats();
            }
        } catch (Exception e) {
            log.error("Ошибка при разблокировке пользователя для поиска: {}", userId, e);
        }
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

        if (dto.getFirstname() != null) {
            user.setFirstname(dto.getFirstname());
        }
        if (dto.getSubname() != null) {
            user.setSubname(dto.getSubname());
        }
        if (dto.getDescription() != null) {
            user.setDescription(dto.getDescription());
        }
        if (dto.getAvatar() != null) {
            user.setAvatar(dto.getAvatar());
        }
        if (dto.getCity() != null) {
            user.setCity(dto.getCity());
        }
        if (dto.getAge() != null) {
            user.setAge(dto.getAge());
        }
        if (dto.getPurposes() != null) {
            user.setPurposes(new ArrayList<>(dto.getPurposes()));
        }
        if (dto.getInterests() != null) {
            user.setInterests(new ArrayList<>(dto.getInterests()));
        }
        if (dto.getIsSearchable() != null) {
            user.setIsSearchable(dto.getIsSearchable());
        }
        if (dto.getImages() != null) {
            user.setImages(new ArrayList<>(dto.getImages()));
        }
        return userRepository.save(user);
    }

    @Transactional
    public void updatePassword(UUID userId, String oldPassword, String newPassword) {
        User user = getById(userId);
        String oldPasswordHash = encryptionUtils.hashPassword(oldPassword);
        if (!user.getPassword().equals(oldPasswordHash)) {
            throw new RuntimeException("Old password is incorrect");
        }

        user.setPassword(oldPasswordHash);
        userRepository.save(user);
    }

    @Transactional
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

            userRepository.flush();

            long currentOnline = userRepository.countByIsOnlineTrue();
            log.info("Статус онлайн пользователя {} изменен на: {}. Сейчас онлайн: {}",
                    userId, isOnline, currentOnline);

            statisticsService.refreshAndBroadcastStats();

            long verifiedOnline = userRepository.countByIsOnlineTrue();
            log.info("Проверка после обновления: онлайн пользователей: {}", verifiedOnline);
        } else {
            log.debug("Статус онлайн пользователя {} уже установлен в: {}", userId, isOnline);
        }
    }

    @Transactional
    public void setUserSearching(UUID userId, boolean isSearching) {
        User user = getById(userId);

        if (user.getIsSearching() != isSearching) {
            user.setIsSearching(isSearching);
            userRepository.save(user);

            userRepository.flush();

            long currentSearching = userRepository.countByIsSearchingTrue();
            log.info("Статус поиска пользователя {} изменен на: {}. Сейчас в поиске: {}",
                    userId, isSearching, currentSearching);

            statisticsService.refreshAndBroadcastStats();

            long verifiedSearching = userRepository.countByIsSearchingTrue();
            log.info("Проверка после обновления: в поиске пользователей: {}", verifiedSearching);
        }
    }

    @Transactional
    public void startSearch(UUID userId) {
        try {
            User user = getById(userId);

            if (!user.getIsOnline()) {
                log.warn("Пользователь {} не онлайн, нельзя начать поиск", userId);
                throw new RuntimeException("User must be online to start search");
            }

            if (!user.getIsSearchable()) {
                log.warn("Пользователь {} не доступен для поиска (isSearchable=false)", userId);
                throw new RuntimeException("User must be searchable to start search");
            }

            user.setIsSearching(true);
            userRepository.save(user);

            statisticsService.refreshAndBroadcastStats();

            log.info("Пользователь {} начал поиск. Статусы: online={}, searchable={}, searching={}",
                    userId, user.getIsOnline(), user.getIsSearchable(), true);
        } catch (RuntimeException e) {
            log.error("Ошибка при старте поиска для пользователя {}", userId, e);
            throw new RuntimeException("Failed to start search", e);
        }
    }

    @Transactional
    public void stopSearch(UUID userId) {
        try {
            User user = getById(userId);
            user.setIsSearching(false);
            userRepository.save(user);

            statisticsService.refreshAndBroadcastStats();

            log.info("Пользователь {} остановил поиск. Статусы: searchable={}, searching={}",
                    userId, user.getIsSearchable(), false);
        } catch (Exception e) {
            log.error("Ошибка при остановке поиска для пользователя {}", userId, e);
            throw new RuntimeException("Failed to stop search", e);
        }
    }

    @Transactional(readOnly = true)
    public boolean isUserAvailableForSearch(UUID userId) {
        try {
            User user = getById(userId);
            return user.getIsOnline() &&
                    user.getIsSearchable() &&
                    user.getIsSearching();
        } catch (Exception e) {
            log.error("Ошибка при проверке доступности пользователя {}", userId, e);
            return false;
        }
    }

    @Transactional(readOnly = true)
    public List<User> getSearchingUsers() {
        return userRepository.findByIsSearchingTrue();
    }

    @Transactional(readOnly = true)
    public List<User> getSearchableUsers() {
        return userRepository.findByIsSearchableTrue();
    }

    @Transactional
    public void setUserAvatar(UUID userId, String url) {
        try {
            log.info("Setting avatar for user {}: {}", userId, url);
            User user = getById(userId);
            user.setAvatar(url);
            userRepository.save(user);
            log.info("Avatar set successfully for user {}", userId);
        } catch (Exception e) {
            log.error("Error setting avatar for user {}", userId, e);
            throw new RuntimeException("Failed to set avatar", e);
        }
    }

    @Transactional
    public void setUserImages(UUID userId, List<String> imageUrls) {
        try {
            log.info("Setting {} images for user {}", imageUrls.size(), userId);
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new EntityNotFoundException("User not found"));

            user.setImages(Collections.synchronizedList(new ArrayList<>(imageUrls)));
            userRepository.save(user);
            log.info("Images set successfully for user {}", userId);
        } catch (Exception e) {
            log.error("Error setting images for user {}", userId, e);
            throw new RuntimeException("Failed to set images", e);
        }
    }

    @Transactional
    public void addUserImage(UUID userId, String imageUrl) {
        try {
            log.info("Adding image for user {}: {}", userId, imageUrl);
            User user = getById(userId);
            List<String> images = user.getImages();
            if (images == null) {
                images = Collections.synchronizedList(new ArrayList<>());
            } else {
                images = new ArrayList<>(images);
            }
            images.add(imageUrl);
            user.setImages(Collections.synchronizedList(images));
            userRepository.save(user);
            log.info("Image added successfully for user {}", userId);
        } catch (Exception e) {
            log.error("Error adding image for user {}", userId, e);
            throw new RuntimeException("Failed to add image", e);
        }
    }

    @Transactional(readOnly = true)
    public String getUserAvatar(UUID userId) {
        User user = getById(userId);
        return user.getAvatar();
    }

    @Transactional(readOnly = true)
    public List<String> getUserImages(UUID userId) {
        User user = getById(userId);
        return user.getImages() != null ? user.getImages() : Collections.emptyList();
    }

    @Transactional
    public void removeUserAvatar(UUID userId) {
        try {
            log.info("Removing avatar for user {}", userId);
            User user = getById(userId);
            user.setAvatar(null);
            userRepository.save(user);
            log.info("Avatar removed successfully for user {}", userId);
        } catch (Exception e) {
            log.error("Error removing avatar for user {}", userId, e);
            throw new RuntimeException("Failed to remove avatar", e);
        }
    }

    @Transactional
    public void removeUserImage(UUID userId, String imageUrl) {
        try {
            log.info("Removing image for user {}: {}", userId, imageUrl);
            User user = getById(userId);
            List<String> images = user.getImages();
            if (images != null) {
                images.remove(imageUrl);
                user.setImages(images);
                userRepository.save(user);
            }
            log.info("Image removed successfully for user {}", userId);
        } catch (Exception e) {
            log.error("Error removing image for user {}", userId, e);
            throw new RuntimeException("Failed to remove image", e);
        }
    }

    @Transactional
    public void removeAllUserImages(UUID userId) {
        try {
            log.info("Removing all images for user {}", userId);
            User user = getById(userId);
            user.setImages(new ArrayList<>());
            userRepository.save(user);
            log.info("All images removed successfully for user {}", userId);
        } catch (Exception e) {
            log.error("Error removing all images for user {}", userId, e);
            throw new RuntimeException("Failed to remove all images", e);
        }
    }

    private UserDto mapToDto(User user) {
        UserDto dto = new UserDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFirstname(user.getFirstname());
        dto.setSubname(user.getSubname());
        dto.setDescription(user.getDescription());
        dto.setAvatar(user.getAvatar());
        dto.setCity(user.getCity());
        dto.setAge(user.getAge());
        dto.setCreatedAt(user.getCreatedAt());
        dto.setVerified(user.getVerified());
        dto.setIsSearchable(user.getIsSearchable());
        dto.setIsOnline(user.getIsOnline());
        dto.setGamePoints(user.getGamePoints());
        dto.setImages(user.getImages());

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