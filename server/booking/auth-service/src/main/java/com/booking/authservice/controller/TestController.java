package com.booking.authservice.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class TestController {

    @GetMapping("/public/test")
    public String publicEndpoint() {
        return "Public endpoint - доступен всем";
    }

    @GetMapping("/user/test")
    public String userEndpoint(@AuthenticationPrincipal Jwt jwt) {
        return "User endpoint - доступен пользователям с ролью 'user'. Username: " + jwt.getClaimAsString("preferred_username");
    }

    @GetMapping("/admin/test")
    public String adminEndpoint(@AuthenticationPrincipal Jwt jwt) {
        return "Admin endpoint - доступен администраторам. Username: " + jwt.getClaimAsString("preferred_username");
    }
} 