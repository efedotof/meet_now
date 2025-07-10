package com.efedotov.meet_now.meet_now.controller.friend;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/v1/friend")
@Tag(name = "Friend", description = "Управление друзьями: отправка и подтверждение запросов в друзья, удаление из друзей, список друзей")
public class FriendController {
    
}
