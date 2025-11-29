package com.efedotov.meet_now.meet_now.config;

import java.io.IOException;
import java.io.InputStream;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
public class FirebaseConfig {

    @Value("${app.firebase.config.path}")
    private String firebaseConfigPath;

    @PostConstruct
    public void initialize() {
        try {
            if (FirebaseApp.getApps().isEmpty()) {

                InputStream serviceAccount = getConfigFileStream();

                if (serviceAccount == null) {
                    log.warn("Firebase config file not found. Firebase notifications will be disabled.");
                    return;
                }

                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                        .build();

                FirebaseApp.initializeApp(options);
                log.info("Firebase initialized successfully");
            } else {
                log.info("Firebase already initialized");
            }
        } catch (IOException e) {
            log.error("Failed to initialize Firebase. Notifications will be disabled.", e);
        } catch (Exception e) {
            log.error("Unexpected error during Firebase initialization", e);
        }
    }

    private InputStream getConfigFileStream() throws IOException {
        ClassPathResource resource = new ClassPathResource(firebaseConfigPath);
        if (resource.exists()) {
            return resource.getInputStream();
        } else {
            log.debug("Firebase config not found in classpath");
            return null;
        }
    }
}