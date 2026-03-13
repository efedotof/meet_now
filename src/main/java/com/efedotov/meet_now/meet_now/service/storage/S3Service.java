package com.efedotov.meet_now.meet_now.service.storage;

import java.io.IOException;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import software.amazon.awssdk.awscore.exception.AwsServiceException;
import software.amazon.awssdk.core.exception.SdkClientException;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;
import software.amazon.awssdk.services.s3.presigner.model.PresignedGetObjectRequest;

@Service
@RequiredArgsConstructor
@Slf4j
public class S3Service {

    private final S3Client s3Client;
    private final S3Presigner s3Presigner;

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    public String uploadFile(MultipartFile file) throws IOException {
        try {
            log.info("Uploading file: {}, size: {}, type: {}",
                    file.getOriginalFilename(), file.getSize(), file.getContentType());
            String originalFilename = file.getOriginalFilename();

            String extension = getFileExtension(originalFilename, file.getContentType());
            String fileName = UUID.randomUUID() + extension;

            byte[] fileBytes = file.getBytes();

            Map<String, String> metadata = new HashMap<>();
            metadata.put("Content-Type", file.getContentType());
            metadata.put("Content-Length", String.valueOf(fileBytes.length));
            metadata.put("Original-Filename", originalFilename);

            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(fileName)
                    .metadata(metadata)
                    .contentType(file.getContentType())
                    .contentLength((long) fileBytes.length)
                    .build();

            log.debug("Uploading file to bucket: {}, key: {}", bucketName, fileName);

            s3Client.putObject(putObjectRequest, RequestBody.fromBytes(fileBytes));

            return "https://s3.ru1.storage.beget.cloud/" + bucketName + "/" + fileName;

        } catch (S3Exception e) {
            log.error("S3 Error: {}", e.awsErrorDetails().errorMessage(), e);
            throw new IOException("S3 upload failed: " + e.awsErrorDetails().errorMessage(), e);
        } catch (IOException | AwsServiceException | SdkClientException e) {
            log.error("Unexpected error during S3 upload", e);
            throw new IOException("Upload failed", e);
        }
    }

    private String getFileExtension(String filename, String mimeType) {
        if (filename != null && !filename.isEmpty()) {
            int lastDotIndex = filename.lastIndexOf('.');
            if (lastDotIndex > 0 && lastDotIndex < filename.length() - 1) {
                String ext = filename.substring(lastDotIndex).toLowerCase();
                if (isValidExtension(ext)) {
                    return ext;
                }
            }
        }

        if (mimeType != null) {
            switch (mimeType) {
                case "image/jpeg", "image/jpg" -> {
                    return ".jpg";
                }
                case "image/png" -> {
                    return ".png";
                }
                case "image/gif" -> {
                    return ".gif";
                }
                case "image/bmp" -> {
                    return ".bmp";
                }
                case "image/webp" -> {
                    return ".webp";
                }
                case "image/svg+xml" -> {
                    return ".svg";
                }
                case "video/mp4" -> {
                    return ".mp4";
                }
                case "video/avi" -> {
                    return ".avi";
                }
                case "video/quicktime" -> {
                    return ".mov";
                }
                case "video/x-msvideo" -> {
                    return ".avi";
                }
                case "video/mpeg" -> {
                    return ".mpeg";
                }
                case "video/webm" -> {
                    return ".webm";
                }
                case "application/pdf" -> {
                    return ".pdf";
                }
                case "application/msword" -> {
                    return ".doc";
                }
                case "application/vnd.openxmlformats-officedocument.wordprocessingml.document" -> {
                    return ".docx";
                }
                case "application/vnd.ms-excel" -> {
                    return ".xls";
                }
                case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" -> {
                    return ".xlsx";
                }
                case "text/plain" -> {
                    return ".txt";
                }
                default -> {
                    log.warn("Unknown MIME type: {}, using .bin extension", mimeType);
                    return ".bin";
                }
            }
        }

        log.warn("Cannot determine file extension for filename: {} and MIME type: {}, using .bin", filename, mimeType);
        return ".bin";
    }

    private boolean isValidExtension(String extension) {
        String[] validExtensions = {
                ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp", ".svg",
                ".mp4", ".avi", ".mov", ".mpeg", ".webm", ".mkv",
                ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".txt",
                ".zip", ".rar", ".7z"
        };

        for (String validExt : validExtensions) {
            if (validExt.equals(extension.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    public String generatePresignedUrl(String objectKey, Duration duration) {
        try {
            GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                    .bucket(bucketName)
                    .key(objectKey)
                    .build();

            GetObjectPresignRequest presignRequest = GetObjectPresignRequest.builder()
                    .signatureDuration(duration)
                    .getObjectRequest(getObjectRequest)
                    .build();

            PresignedGetObjectRequest presignedRequest = s3Presigner.presignGetObject(presignRequest);
            return presignedRequest.url().toString();
        } catch (Exception e) {
            log.error("Error generating presigned URL", e);
            throw new RuntimeException("Failed to generate presigned URL", e);
        }
    }

    public String getObjectKeyFromUrl(String fileUrl) {
        String prefix = "https://s3.ru1.storage.beget.cloud/" + bucketName + "/";
        if (fileUrl != null && fileUrl.startsWith(prefix)) {
            return fileUrl.substring(prefix.length());
        }
        return null;
    }

    public void deleteFile(String fileUrl) {
        try {
            String objectKey = getObjectKeyFromUrl(fileUrl);
            log.info("Deleting file from S3: {}", objectKey);

            DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(objectKey)
                    .build();

            s3Client.deleteObject(deleteObjectRequest);
            log.info("File successfully deleted from S3: {}", objectKey);
        } catch (S3Exception e) {
            log.error("S3 Error deleting file: {}", e.awsErrorDetails().errorMessage(), e);
            throw new RuntimeException("S3 delete failed: " + e.awsErrorDetails().errorMessage(), e);
        } catch (AwsServiceException | SdkClientException e) {
            log.error("Unexpected error during S3 delete", e);
            throw new RuntimeException("Delete failed", e);
        }
    }
}