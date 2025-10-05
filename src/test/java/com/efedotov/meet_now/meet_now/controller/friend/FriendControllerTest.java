package com.efedotov.meet_now.meet_now.controller.friend;

import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import static org.mockito.Mockito.when;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.efedotov.meet_now.meet_now.controller.social.FriendController;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.service.social.FriendService;

@WebMvcTest(FriendController.class)
public class FriendControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Mock
    private FriendService friendService;


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
