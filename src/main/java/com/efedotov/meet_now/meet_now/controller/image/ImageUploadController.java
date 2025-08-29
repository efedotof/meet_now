package com.efedotov.meet_now.meet_now.controller.image;

import java.io.IOException;
import java.util.List;

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

    @PostMapping("/upload-images")
    @Operation(summary = "Загрузить изображения профиля пользователя")
    public ResponseEntity<List<String>> uploadImages(@RequestParam("files") List<MultipartFile> files) {
        try {
            List<String> fileUrls = files.stream()
                    .map(file -> {
                        try {
                            String fileName = s3Service.uploadFile(file);
                            return "https://s3.ru1.storage.beget.cloud/" + fileName;
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }).toList();
            return ResponseEntity.ok(fileUrls);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

}