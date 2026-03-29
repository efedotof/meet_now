package com.efedotov.meet_now.meet_now.dto.request.keys;

import lombok.Data;

@Data
public class SaltUploadRequest {
    private String salt;
}