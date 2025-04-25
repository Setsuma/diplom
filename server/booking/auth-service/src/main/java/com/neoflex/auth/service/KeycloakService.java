package com.neoflex.auth.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class KeycloakService {
    
    @Value("${keycloak.auth-server-url}")
    private String keycloakUrl;
    
    @Value("${keycloak.realm}")
    private String realm;
    
    private final RestTemplate restTemplate;
    
    public KeycloakService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    public Map<String, Object> getJwks() {
        String jwksUrl = String.format("%s/realms/%s/protocol/openid-connect/certs", keycloakUrl, realm);
        return restTemplate.getForObject(jwksUrl, Map.class);
    }
} 