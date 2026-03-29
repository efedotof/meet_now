package com.efedotov.meet_now.meet_now.dto.response.keys;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PublicKeyResponse {
    private String publicKey;
}