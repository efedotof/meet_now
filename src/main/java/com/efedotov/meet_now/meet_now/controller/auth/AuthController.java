package com.efedotov.meet_now.meet_now.controller.auth;

import java.util.Optional;

import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.LoginDTO;
import com.efedotov.meet_now.meet_now.dto.RegistrationDTO;
import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.UserRepository;
import com.efedotov.meet_now.meet_now.until.EncryptionUtils;

import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "Auth", description = "Эндпоинты для регистрации, входа, выхода и управления аутентификацией")
public class AuthController {
    private final UserRepository userRepository;
    private final EncryptionUtils encryptionUtils;

    public AuthController(UserRepository userRepository, EncryptionUtils encryptionUtils) {
        this.userRepository = userRepository;
        this.encryptionUtils = encryptionUtils;
    }

    @PostMapping("/register")
    public ResponseEntity<?> registration(@RequestBody RegistrationDTO dto) {
        try {
            Optional<User> existingUserByUsername = userRepository.findByUsername(dto.getUsername());
            if (existingUserByUsername.isPresent()) {
                return ResponseEntity.status(409).body("Пользователь с таким username уже существует.");
            }

            Optional<User> existingUserByEmail = userRepository.findByEmail(dto.getEmail());
            if (existingUserByEmail.isPresent()) {
                return ResponseEntity.status(409).body("Пользователь с таким email уже существует.");
            }

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

            User savedUser = userRepository.save(user);

            UserDto userDto = mapToDto(savedUser);
            return ResponseEntity.ok(userDto);

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Что-то пошло не так: " + e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginDTO dto) {
        try {
            Optional<User> userOpt = userRepository.findByUsername(dto.getUsername());
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(404).body("Пользователь не найден.");
            }
            User user = userOpt.get();
            String hashedInputPassword = encryptionUtils.hashPassword(dto.getPassword());

            if (!user.getPassword().equals(hashedInputPassword)) {
                return ResponseEntity.status(401).body("Неверный пароль.");
            }
            UserDto userDto = mapToDto(user);
            return ResponseEntity.ok(userDto);

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Ошибка при входе: " + e.getMessage());
        }
    }

    private UserDto mapToDto(User user) {
        UserDto dto = new UserDto();
        BeanUtils.copyProperties(user, dto);
        return dto;
    }

}
