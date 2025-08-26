package com.efedotov.meet_now.meet_now.controller.image;


import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.efedotov.meet_now.meet_now.service.user.S3Service;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/uploads")
@RequiredArgsConstructor
public class ImageUploadController {

    private final S3Service s3Service;

    @PostMapping("/upload-avatar")
     @Operation(summary = "Загрузить аватар пользователя")
    public ResponseEntity<String> uploadAvatar(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = s3Service.uploadFile(file);
            String fileUrl = "https://s3.ru1.storage.beget.cloud/" + fileName; 
            return ResponseEntity.ok(fileUrl);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Ошибка загрузки изображения");
        }
    }
}