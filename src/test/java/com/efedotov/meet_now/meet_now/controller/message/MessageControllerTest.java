// package com.efedotov.meet_now.meet_now.controller.message;

// import com.efedotov.meet_now.meet_now.model.Message;
// import com.efedotov.meet_now.meet_now.service.MessageService;

// import org.junit.jupiter.api.BeforeEach;
// import org.junit.jupiter.api.Test;
// import org.mockito.InjectMocks;
// import org.mockito.Mock;
// import org.mockito.MockitoAnnotations;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
// import org.springframework.test.web.servlet.MockMvc;

// import java.util.List;
// import java.util.UUID;

// import static org.mockito.Mockito.when;
// import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// @WebMvcTest(MessageController.class)
// public class MessageControllerTest {

//     @Autowired
//     private MockMvc mockMvc;

//     @Mock
//     private MessageService messageService;

//     @InjectMocks
//     private MessageController messageController;

//     @BeforeEach
//     void setUp() {
//         MockitoAnnotations.openMocks(this);
//     }

//     @Test
//     void testGetMessagesByChatId() throws Exception {
//         UUID chatId = UUID.randomUUID();

//         Message message1 = new Message();
//         message1.setId(UUID.randomUUID());
//         message1.setText("Hello");

//         Message message2 = new Message();
//         message2.setId(UUID.randomUUID());
//         message2.setText("Hi");

//         List<Message> messages = List.of(message1, message2);

//         when(messageService.getMessagesByChatId(chatId)).thenReturn(messages);

//         mockMvc.perform(get("/api/v1/message/chat/{chatId}", chatId))
//                 .andExpect(status().isOk())
//                 .andExpect(jsonPath("$.length()").value(messages.size()))
//                 .andExpect(jsonPath("$[0].text").value("Hello"));
//     }
// }
