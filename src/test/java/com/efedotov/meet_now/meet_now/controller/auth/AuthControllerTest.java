package com.efedotov.meet_now.meet_now.controller.auth;

import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.any;
import org.mockito.Mock;
import static org.mockito.Mockito.when;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.efedotov.meet_now.meet_now.dto.request.auth.LoginDTO;
import com.efedotov.meet_now.meet_now.dto.request.auth.RegistrationDTO;
import com.efedotov.meet_now.meet_now.dto.response.social.UserDto;
import com.efedotov.meet_now.meet_now.service.auth.AuthService;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebMvcTest(AuthController.class)
public class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Mock
    private AuthService authService;



    @Test
    void testRegistrationSuccess() throws Exception {
        RegistrationDTO dto = new RegistrationDTO();
        dto.setUsername("user");
        dto.setPassword("password");
        dto.setEmail("user@example.com");

        UserDto userDto = new UserDto();
        userDto.setId(java.util.UUID.randomUUID());
        userDto.setUsername("user");
        userDto.setEmail("user@example.com");

        when(authService.register(any(RegistrationDTO.class))).thenReturn(userDto);

        mockMvc.perform(post("/api/v1/auth/register")
                .contentType("application/json")
                .content(objectMapper.writeValueAsString(dto)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username").value("user"))
                .andExpect(jsonPath("$.email").value("user@example.com"));
    }

    @Test
    void testLoginSuccess() throws Exception {
        LoginDTO dto = new LoginDTO();
        dto.setUsername("user");
        dto.setPassword("password");

        UserDto userDto = new UserDto();
        userDto.setId(java.util.UUID.randomUUID());
        userDto.setUsername("user");

        when(authService.login(any(LoginDTO.class))).thenReturn(userDto);

        mockMvc.perform(post("/api/v1/auth/login")
                .contentType("application/json")
                .content(objectMapper.writeValueAsString(dto)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username").value("user"));
    }
}
