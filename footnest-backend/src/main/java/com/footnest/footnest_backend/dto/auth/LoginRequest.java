package com.footnest.footnest_backend.dto.auth;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequest {

    private String username;

    private String password;

}
