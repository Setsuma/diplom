package com.neoflex.auth.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {
    private String accessToken;
    private String refreshToken;
    private Long expiresIn;

    public static AuthResponse of(String accessToken, String refreshToken, Long expiresIn) {
        return new AuthResponse(accessToken, refreshToken, expiresIn);
    }
} 