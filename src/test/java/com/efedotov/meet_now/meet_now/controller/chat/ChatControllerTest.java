package com.efedotov.meet_now.meet_now.controller.chat;

import com.efedotov.meet_now.meet_now.model.*;
import com.efedotov.meet_now.meet_now.service.ChatService;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;

import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.UUID;
import java.util.Optional;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ChatController.class)
public class ChatControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Mock
    private ChatService chatService;

    @InjectMocks
    private ChatController chatController;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testCreateTemporaryChat() throws Exception {
        UUID senderId = UUID.randomUUID();
        UUID recipientId = UUID.randomUUID();
        int duration = 10;

        TemporaryChat tempChat = new TemporaryChat();
        tempChat.setTempChatId(UUID.randomUUID());

        when(chatService.createTemporaryChat(any(), any(), eq(duration)))
                .thenReturn(tempChat);

        mockMvc.perform(post("/api/v1/chat/temporary")
                .param("senderId", senderId.toString())
                .param("recipientId", recipientId.toString())
                .param("durationMinutes", String.valueOf(duration)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.tempChatId").value(tempChat.getTempChatId().toString()));
    }

    @Test
    void testFinishTemporaryChat() throws Exception {
        UUID tempChatId = UUID.randomUUID();

        doNothing().when(chatService).finishTemporaryChat(tempChatId);

        mockMvc.perform(post("/api/v1/chat/temporary/{tempChatId}/finish", tempChatId))
                .andExpect(status().isOk());
    }

    @Test
    void testGetActiveTemporaryChats() throws Exception {
        UUID userId = UUID.randomUUID();

        TemporaryChat chat1 = new TemporaryChat();
        chat1.setTempChatId(UUID.randomUUID());
        TemporaryChat chat2 = new TemporaryChat();
        chat2.setTempChatId(UUID.randomUUID());

        List<TemporaryChat> chats = List.of(chat1, chat2);

        when(chatService.getActiveTemporaryChatsForUser(userId)).thenReturn(chats);

        mockMvc.perform(get("/api/v1/chat/temporary/active").param("userId", userId.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(chats.size()));
    }

    @Test
    void testGetChatConstraintFound() throws Exception {
        UUID tempChatId = UUID.randomUUID();
        ChatConstraint constraint = new ChatConstraint();

        when(chatService.getChatConstraint(tempChatId)).thenReturn(Optional.of(constraint));

        mockMvc.perform(get("/api/v1/chat/temporary/{tempChatId}/constraint", tempChatId))
                .andExpect(status().isOk());
    }

    @Test
    void testGetChatConstraintNotFound() throws Exception {
        UUID tempChatId = UUID.randomUUID();

        when(chatService.getChatConstraint(tempChatId)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/v1/chat/temporary/{tempChatId}/constraint", tempChatId))
                .andExpect(status().isNotFound());
    }
}
