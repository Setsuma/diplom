package com.neoflex.auth.model;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoResponse {
    private String id;
    private String username;
    private String firstName;
    private String lastName;
    private String email;
    private String photoUrl;
    private String[] roles;
} 