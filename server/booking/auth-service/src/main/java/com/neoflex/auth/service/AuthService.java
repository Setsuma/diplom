package com.neoflex.auth.service;

import com.neoflex.auth.model.AuthRequest;
import com.neoflex.auth.model.AuthResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.keycloak.OAuth2Constants;
import org.keycloak.representations.AccessTokenResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.jboss.resteasy.client.jaxrs.internal.ResteasyClientBuilderImpl;
import org.springframework.security.oauth2.jwt.*;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.Form;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    @Value("${keycloak.realm}")
    private String realm;

    @Value("${keycloak.resource}")
    private String clientId;

    @Value("${keycloak.auth-server-url}")
    private String authServerUrl;

    @Value("${keycloak.credentials.secret}")
    private String clientSecret;

    private final JwtDecoder jwtDecoder;

    public AuthResponse authenticate(AuthRequest request) {
        try {
            Keycloak keycloak = KeycloakBuilder.builder()
                    .serverUrl(authServerUrl)
                    .realm(realm)
                    .clientId(clientId)
                    .clientSecret(clientSecret)
                    .username(request.getUsername())
                    .password(request.getPassword())
                    .grantType(OAuth2Constants.PASSWORD)
                    .resteasyClient(new ResteasyClientBuilderImpl().build())
                    .build();

            AccessTokenResponse response = keycloak.tokenManager().getAccessToken();

            return AuthResponse.of(
                    response.getToken(),
                    response.getRefreshToken(),
                    response.getExpiresIn()
            );
        } catch (Exception e) {
            throw new RuntimeException("Authentication failed: " + e.getMessage(), e);
        }
    }

    public AuthResponse refresh(String refreshToken) {
        try {
            Client client = new ResteasyClientBuilderImpl().build();
            String tokenEndpoint = String.format("%s/realms/%s/protocol/openid-connect/token", authServerUrl, realm);

            Form form = new Form()
                    .param("grant_type", OAuth2Constants.REFRESH_TOKEN)
                    .param("refresh_token", refreshToken)
                    .param("client_id", clientId)
                    .param("client_secret", clientSecret);

            Response response = client.target(tokenEndpoint)
                    .request(MediaType.APPLICATION_FORM_URLENCODED)
                    .post(Entity.form(form));

            if (response.getStatus() == 200) {
                AccessTokenResponse tokenResponse = response.readEntity(AccessTokenResponse.class);
                return AuthResponse.of(
                        tokenResponse.getToken(),
                        tokenResponse.getRefreshToken(),
                        tokenResponse.getExpiresIn()
                );
            } else {
                throw new RuntimeException("Failed to refresh token. Status: " + response.getStatus());
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to refresh token: " + e.getMessage(), e);
        }
    }

    public void validateToken(String token) {
        try {
            Jwt jwt = jwtDecoder.decode(token);
            
            // Проверяем издателя
            String issuer = jwt.getIssuer().toString();
            log.debug(issuer);
            log.debug(authServerUrl + "/realms/" + realm);
//            if (!issuer.equals(authServerUrl + "/realms/" + realm)) {
//                throw new JwtValidationException("Invalid token issuer", null);
//            }

            // Проверяем аудиторию
            if (!jwt.getAudience().contains(clientId)) {
                log.warn("1");

                throw new JwtValidationException("Invalid token audience", null);
            }

            // Проверяем роли
            Map<String, Object> realmAccess = jwt.getClaim("realm_access");
            if (realmAccess == null) {
                log.warn("2");
                throw new JwtValidationException("Token does not contain realm_access claim", null);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> resourceAccess = jwt.getClaim("resource_access");
            if (resourceAccess == null) {
                log.warn("3");
                throw new JwtValidationException("Token does not contain resource_access claim", null);
            }
        } catch (JwtException e) {
            log.warn(e.getMessage());
            throw new RuntimeException("Token validation failed: " + e.getMessage(), e);
        }
    }
} 