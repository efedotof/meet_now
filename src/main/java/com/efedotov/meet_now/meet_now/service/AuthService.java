package com.efedotov.meet_now.meet_now.service;

import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.LoginDTO;
import com.efedotov.meet_now.meet_now.dto.RegistrationDTO;
import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.model.Role;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.model.UserSession;
import com.efedotov.meet_now.meet_now.repository.RoleRepository;
import com.efedotov.meet_now.meet_now.repository.UserRepository;
import com.efedotov.meet_now.meet_now.until.EncryptionUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final EncryptionUtils encryptionUtils;
    private final SessionService sessionService;

    public UserDto register(RegistrationDTO dto) {
        Optional<User> existingUserByUsername = userRepository.findByUsername(dto.getUsername());
        if (existingUserByUsername.isPresent()) {
            throw new RuntimeException("Пользователь с таким username уже существует.");
        }

        Optional<User> existingUserByEmail = userRepository.findByEmail(dto.getEmail());
        if (existingUserByEmail.isPresent()) {
            throw new RuntimeException("Пользователь с таким email уже существует.");
        }
        System.out.println("Password from DTO: " + dto.getPassword());

        String hashedPassword = encryptionUtils.hashPassword(dto.getPassword());

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(hashedPassword);
        user.setEmail(dto.getEmail());
        user.setFirstname(dto.getFirstname());
        user.setSubname(dto.getSubname());
        user.setDescription(dto.getDescription());
        user.setAvatar(dto.getAvatar());
        user.setCity(dto.getCity());
        user.setAge(dto.getAge());
        user.setPurposes(dto.getPurposes());
        user.setInterests(dto.getInterests());
        user.setIsSearchable(dto.getIsSearchable());
        user.setFloor(dto.getFloor());
        Role userRole = roleRepository.findByRoleName("USER")
                .orElseThrow(() -> new RuntimeException("Роль USER не найдена в базе"));

        user.setRoles(Set.of(userRole));

        User savedUser = userRepository.save(user);

        UserSession session = sessionService.createSession(savedUser.getId());

        UserDto userDto = mapToDto(savedUser);
        userDto.setToken(session.getToken());

        return userDto;
    }

    public UserDto login(LoginDTO dto) {
        Optional<User> userOpt = userRepository.findByUsername(dto.getUsername());
        if (userOpt.isEmpty()) {
            throw new RuntimeException("Пользователь не найден.");
        }
            
        User user = userOpt.get();
        String hashedInputPassword = encryptionUtils.hashPassword(dto.getPassword());

        if (!user.getPassword().equals(hashedInputPassword)) {
            throw new RuntimeException("Неверный пароль.");
        }

        UserSession session = sessionService.createSession(user.getId());
        UserDto userDto = mapToDto(user);
        userDto.setToken(session.getToken());

        return userDto;
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
