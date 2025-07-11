package com.efedotov.meet_now.meet_now.controller.friend;

import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.service.FriendService;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;

import org.springframework.test.web.servlet.MockMvc;

import java.util.Set;
import java.util.UUID;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(FriendController.class)
public class FriendControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Mock
    private FriendService friendService;

    @InjectMocks
    private FriendController friendController;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testSendFriendRequest() throws Exception {
        UUID fromUserId = UUID.randomUUID();
        UUID toUserId = UUID.randomUUID();

        when(friendService.sendFriendRequest(fromUserId, toUserId)).thenReturn("Request sent");

        mockMvc.perform(post("/api/v1/friend/request/send")
                .param("fromUserId", fromUserId.toString())
                .param("toUserId", toUserId.toString()))
                .andExpect(status().isOk())
                .andExpect(content().string("Request sent"));
    }

    @Test
    void testGetFriends() throws Exception {
        UUID userId = UUID.randomUUID();

        User friend = new User();
        friend.setId(UUID.randomUUID());
        friend.setUsername("friend1");

        Set<User> friendsSet = Set.of(friend);

        when(friendService.getFriends(userId)).thenReturn(friendsSet);

        mockMvc.perform(get("/api/v1/friend/list").param("userId", userId.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].username").value("friend1"));
    }
}
