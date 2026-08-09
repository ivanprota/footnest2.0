package com.footnest.footnest_backend.dto.auth;

public record RegisterResponse(
        String username,
        boolean approved
) {}
