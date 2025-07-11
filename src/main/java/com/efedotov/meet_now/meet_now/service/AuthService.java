package com.efedotov.meet_now.meet_now.service;

import com.efedotov.meet_now.meet_now.dto.LoginDTO;
import com.efedotov.meet_now.meet_now.dto.RegistrationDTO;
import com.efedotov.meet_now.meet_now.dto.UserDto;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.UserRepository;
import com.efedotov.meet_now.meet_now.until.EncryptionUtils;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final EncryptionUtils encryptionUtils;

    public UserDto register(RegistrationDTO dto) {
        Optional<User> existingUserByUsername = userRepository.findByUsername(dto.getUsername());
        if (existingUserByUsername.isPresent()) {
            throw new RuntimeException("Пользователь с таким username уже существует.");
        }

        Optional<User> existingUserByEmail = userRepository.findByEmail(dto.getEmail());
        if (existingUserByEmail.isPresent()) {
            throw new RuntimeException("Пользователь с таким email уже существует.");
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
        return mapToDto(savedUser);
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

        return mapToDto(user);
    }

    private UserDto mapToDto(User user) {
        UserDto dto = new UserDto();
        BeanUtils.copyProperties(user, dto);
        return dto;
    }
}
