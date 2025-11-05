package com.efedotov.meet_now.meet_now.service.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;

@Service
public class TokenEncryptionService {

    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/ECB/PKCS5Padding";

    public String encryptPushToken(String pushToken, String userPassword) throws Exception {
        SecretKeySpec secretKey = generateKey(userPassword);
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] encryptedBytes = cipher.doFinal(pushToken.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    public String decryptPushToken(String encryptedPushToken, String userPassword) throws Exception {
        SecretKeySpec secretKey = generateKey(userPassword);
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decodedBytes = Base64.getDecoder().decode(encryptedPushToken);
        byte[] decryptedBytes = cipher.doFinal(decodedBytes);
        return new String(decryptedBytes, StandardCharsets.UTF_8);
    }

    public String encryptPushTokenWithSalt(String pushToken, String userPassword, String salt) throws Exception {
        String saltedPassword = userPassword + salt;
        return encryptPushToken(pushToken, saltedPassword);
    }

    public String decryptPushTokenWithSalt(String encryptedPushToken, String userPassword, String salt)
            throws Exception {
        String saltedPassword = userPassword + salt;
        return decryptPushToken(encryptedPushToken, saltedPassword);
    }

    public String generateSalt() {
        byte[] array = new byte[16];
        new SecureRandom().nextBytes(array);
        return Base64.getEncoder().encodeToString(array);
    }

    private SecretKeySpec generateKey(String password) throws NoSuchAlgorithmException {
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] key = sha.digest(password.getBytes(StandardCharsets.UTF_8));
        return new SecretKeySpec(key, ALGORITHM);
    }
}