package com.efedotov.meet_now.meet_now.controller.content;

import java.io.IOException;
import java.security.Principal;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.social.UserService;
import com.efedotov.meet_now.meet_now.service.storage.S3Service;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/uploads")
@RequiredArgsConstructor
@Slf4j
public class ImageUploadController {

    private final S3Service s3Service;
    private final UserService userService;

    @PostMapping("/upload-media")
    @Operation(summary = "Загрузить один медиафайл (изображение, видео, документ)")
    public ResponseEntity<String> uploadMedia(@RequestParam("file") MultipartFile file, Principal principal) {
        try {
            log.info("Uploading media file: {}, size: {}, type: {}",
                    file.getOriginalFilename(), file.getSize(), file.getContentType());

            if (file.getSize() > 50 * 1024 * 1024) {
                log.error("Media file too large: {} bytes", file.getSize());
                return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                        .body("Размер файла не должен превышать 50MB");
            }

            if (file.isEmpty()) {
                log.error("Empty media file received: {}", file.getOriginalFilename());
                return ResponseEntity.badRequest().body("Файл не должен быть пустым");
            }

            String fileUrl = s3Service.uploadFile(file);
            log.info("Media file uploaded to S3: {}", fileUrl);

            return ResponseEntity.ok(fileUrl);
        } catch (IOException e) {
            log.error("Error uploading media file", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка загрузки медиафайла: " + e.getMessage());
        } catch (Exception e) {
            log.error("Unexpected error uploading media file", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Неожиданная ошибка: " + e.getMessage());
        }
    }

    @PostMapping("/upload-media-multiple")
    @Operation(summary = "Загрузить несколько медиафайлов")
    public ResponseEntity<List<String>> uploadMultipleMedia(@RequestParam("files") List<MultipartFile> files,
            Principal principal) {
        try {
            log.info("Received {} media files for upload", files.size());

            if (files.isEmpty()) {
                log.warn("No media files received for upload");
                return ResponseEntity.badRequest().body(Collections.emptyList());
            }

            for (MultipartFile file : files) {
                if (file.getSize() > 50 * 1024 * 1024) {
                    log.error("Media file too large: {} bytes, name: {}", file.getSize(), file.getOriginalFilename());
                    return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body(Collections.emptyList());
                }

                if (file.isEmpty()) {
                    log.error("Empty media file received: {}", file.getOriginalFilename());
                    return ResponseEntity.badRequest().body(Collections.emptyList());
                }
            }

            List<String> fileUrls = new ArrayList<>();
            List<String> errors = new ArrayList<>();

            for (MultipartFile file : files) {
                try {
                    log.info("Uploading media file: {}, size: {}, type: {}",
                            file.getOriginalFilename(), file.getSize(), file.getContentType());
                    String url = s3Service.uploadFile(file);
                    log.info("Media file uploaded successfully: {}", url);
                    fileUrls.add(url);
                } catch (IOException e) {
                    String errorMsg = "Error uploading media file: " + file.getOriginalFilename() + " - "
                            + e.getMessage();
                    log.error(errorMsg, e);
                    errors.add(errorMsg);
                    fileUrls.add(null);
                }
            }

            long successfulUploads = fileUrls.stream().filter(Objects::nonNull).count();

            if (successfulUploads == 0) {
                log.error("All media file uploads failed. Errors: {}", errors);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Collections.emptyList());
            }

            log.info("Successfully uploaded {}/{} media files", successfulUploads, files.size());
            return ResponseEntity.ok(fileUrls);

        } catch (Exception e) {
            log.error("Error uploading media files", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @DeleteMapping("/media")
    @Operation(summary = "Удалить медиафайл")
    public ResponseEntity<String> deleteMedia(@RequestParam("fileUrl") String fileUrl, Principal principal) {
        try {
            log.info("Deleting media file: {}", fileUrl);

            s3Service.deleteFile(fileUrl);
            log.info("Media file successfully deleted from S3: {}", fileUrl);

            return ResponseEntity.ok("Медиафайл успешно удален");
        } catch (Exception e) {
            log.error("Error deleting media file: {}", fileUrl, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка удаления медиафайла: " + e.getMessage());
        }
    }

    @GetMapping("/presigned-url")
    @Operation(summary = "Получить временный URL для доступа к изображению")
    public ResponseEntity<String> getPresignedUrl(@RequestParam("fileUrl") String fileUrl, Principal principal) {
        try {
            log.info("Generating presigned URL for file: {}", fileUrl);
            String objectKey = s3Service.getObjectKeyFromUrl(fileUrl);
            String presignedUrl = s3Service.generatePresignedUrl(objectKey, Duration.ofHours(1));
            log.info("Successfully generated presigned URL for object key: {}", objectKey);
            return ResponseEntity.ok(presignedUrl);
        } catch (Exception e) {
            log.error("Error generating presigned URL for file: {}", fileUrl, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка генерации URL доступа: " + e.getMessage());
        }
    }

    @PostMapping("/upload-avatar")
    @Operation(summary = "Загрузить аватар пользователя")
    public ResponseEntity<String> uploadAvatar(@RequestParam("file") MultipartFile file, Principal principal) {
        try {
            log.info("Uploading avatar file: {}, size: {}", file.getOriginalFilename(), file.getSize());

            if (file.getSize() > 10 * 1024 * 1024) {
                log.error("Avatar file too large: {} bytes", file.getSize());
                return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                        .body("Размер файла не должен превышать 10MB");
            }

            String fileUrl = s3Service.uploadFile(file);
            log.info("Avatar uploaded to S3: {}", fileUrl);

            CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
            UUID senderId = userDetails.getUserId();

            userService.setUserAvatar(senderId, fileUrl);
            log.info("Avatar URL saved to database for user: {}", senderId);

            return ResponseEntity.ok(fileUrl);
        } catch (IOException e) {
            log.error("Error uploading avatar", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка загрузки изображения: " + e.getMessage());
        } catch (Exception e) {
            log.error("Unexpected error uploading avatar", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Неожиданная ошибка: " + e.getMessage());
        }
    }

    @PostMapping("/upload-images")
    @Operation(summary = "Загрузить изображения профиля пользователя")
    public ResponseEntity<List<String>> uploadImages(@RequestParam("files") List<MultipartFile> files,
            Principal principal) {
        try {
            log.info("Received {} images for upload", files.size());

            if (files.isEmpty()) {
                log.warn("No files received for upload");
                return ResponseEntity.badRequest().body(Collections.emptyList());
            }

            for (MultipartFile file : files) {
                if (file.getSize() > 10 * 1024 * 1024) {
                    log.error("File too large: {} bytes", file.getSize());
                    return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body(Collections.emptyList());
                }

                if (file.isEmpty()) {
                    log.error("Empty file received: {}", file.getOriginalFilename());
                    return ResponseEntity.badRequest().body(Collections.emptyList());
                }
            }

            CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
            UUID senderId = userDetails.getUserId();

            List<String> fileUrls = new ArrayList<>();
            List<String> errors = new ArrayList<>();

            for (MultipartFile file : files) {
                try {
                    log.info("Uploading file: {}, size: {}", file.getOriginalFilename(), file.getSize());
                    String url = s3Service.uploadFile(file);
                    log.info("File uploaded successfully: {}", url);
                    fileUrls.add(url);
                } catch (IOException e) {
                    String errorMsg = "Error uploading file: " + file.getOriginalFilename() + " - " + e.getMessage();
                    log.error(errorMsg, e);
                    errors.add(errorMsg);
                    fileUrls.add(null);
                }
            }

            long successfulUploads = fileUrls.stream().filter(Objects::nonNull).count();

            if (successfulUploads == 0) {
                log.error("All file uploads failed. Errors: {}", errors);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Collections.emptyList());
            }

            List<String> successfulUrls = fileUrls.stream()
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());

            log.info("Saving {} image URLs to database for user: {}", successfulUrls.size(), senderId);
            userService.setUserImages(senderId, successfulUrls);
            log.info("Image URLs saved successfully");

            return ResponseEntity.ok(fileUrls);

        } catch (Exception e) {
            log.error("Error uploading images", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @PostMapping("/upload-image")
    @Operation(summary = "Загрузить одно изображение профиля пользователя")
    public ResponseEntity<String> uploadImage(@RequestParam("file") MultipartFile file, Principal principal) {
        try {
            log.info("Uploading single image file: {}, size: {}", file.getOriginalFilename(), file.getSize());

            if (file.getSize() > 10 * 1024 * 1024) {
                log.error("Image file too large: {} bytes", file.getSize());
                return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                        .body("Размер файла не должен превышать 10MB");
            }

            String fileUrl = s3Service.uploadFile(file);
            log.info("Image uploaded to S3: {}", fileUrl);

            CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
            UUID senderId = userDetails.getUserId();

            userService.addUserImage(senderId, fileUrl);
            log.info("Image URL added to database for user: {}", senderId);

            return ResponseEntity.ok(fileUrl);
        } catch (IOException e) {
            log.error("Error uploading image", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка загрузки изображения: " + e.getMessage());
        } catch (Exception e) {
            log.error("Unexpected error uploading image", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Неожиданная ошибка: " + e.getMessage());
        }
    }

    @DeleteMapping("/avatar")
    @Operation(summary = "Удалить аватар пользователя")
    public ResponseEntity<String> deleteAvatar(Principal principal) {
        try {
            CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
            UUID senderId = userDetails.getUserId();

            String currentAvatar = userService.getUserAvatar(senderId);

            if (currentAvatar != null) {
                s3Service.deleteFile(currentAvatar);
                log.info("Avatar deleted from S3: {}", currentAvatar);
            }

            userService.removeUserAvatar(senderId);
            log.info("Avatar removed from database for user: {}", senderId);

            return ResponseEntity.ok("Аватар успешно удален");
        } catch (Exception e) {
            log.error("Error deleting avatar", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка удаления аватара: " + e.getMessage());
        }
    }

    @DeleteMapping("/image")
    @Operation(summary = "Удалить одно изображение пользователя")
    public ResponseEntity<String> deleteImage(@RequestParam("imageUrl") String imageUrl, Principal principal) {
        try {
            CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
            UUID senderId = userDetails.getUserId();

            s3Service.deleteFile(imageUrl);
            log.info("Image deleted from S3: {}", imageUrl);

            userService.removeUserImage(senderId, imageUrl);
            log.info("Image removed from database for user: {}", senderId);

            return ResponseEntity.ok("Изображение успешно удалено");
        } catch (Exception e) {
            log.error("Error deleting image", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка удаления изображения: " + e.getMessage());
        }
    }

    @DeleteMapping("/images/all")
    @Operation(summary = "Удалить все изображения пользователя")
    public ResponseEntity<String> deleteAllImages(Principal principal) {
        try {
            CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
            UUID senderId = userDetails.getUserId();

            List<String> currentImages = userService.getUserImages(senderId);

            for (String imageUrl : currentImages) {
                s3Service.deleteFile(imageUrl);
                log.info("Image deleted from S3: {}", imageUrl);
            }

            userService.removeAllUserImages(senderId);
            log.info("All images removed from database for user: {}", senderId);

            return ResponseEntity.ok("Все изображения успешно удалены");
        } catch (Exception e) {
            log.error("Error deleting all images", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ошибка удаления изображений: " + e.getMessage());
        }
    }
}