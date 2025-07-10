package com.efedotov.meet_now.meet_now.controller.chat;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/v1/chat")
@Tag(name = "Chat", description = "Управление чатами: создание временного чата, завершение чата, получение списка активных чатов, история сообщений")
public class ChatController {

}
