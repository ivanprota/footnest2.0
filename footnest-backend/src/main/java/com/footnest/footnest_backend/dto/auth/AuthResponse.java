package com.footnest.footnest_backend.dto.auth;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
public class AuthResponse {

    private String token;

    private String username;

    private boolean admin;

}
