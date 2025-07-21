package com.efedotov.meet_now.meet_now.controller.icebreaker;

import com.efedotov.meet_now.meet_now.model.IcebreakerTopec;
import com.efedotov.meet_now.meet_now.service.chat.IcebreakerService;

import org.junit.jupiter.api.Test;
import org.mockito.Mock;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(IcebreakerController.class)
public class IcebreakerControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Mock
    private IcebreakerService icebreakerService;

    @Test
    void testGetAllIcebreakerTopics() throws Exception {
        IcebreakerTopec topic1 = new IcebreakerTopec();
        topic1.setId(1L);
        topic1.setText("Topic 1");

        IcebreakerTopec topic2 = new IcebreakerTopec();
        topic2.setId(2L);
        topic2.setText("Topic 2");

        List<IcebreakerTopec> topics = List.of(topic1, topic2);

        when(icebreakerService.getAllTopics()).thenReturn(topics);

        mockMvc.perform(get("/api/v1/icebreaker/topics"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(topics.size()))
                .andExpect(jsonPath("$[0].text").value("Topic 1"));
    }
}
