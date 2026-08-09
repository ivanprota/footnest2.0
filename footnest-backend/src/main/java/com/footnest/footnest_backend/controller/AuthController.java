package com.footnest.footnest_backend.controller;


import com.footnest.footnest_backend.dto.auth.AuthResponse;
import com.footnest.footnest_backend.dto.auth.LoginRequest;
import com.footnest.footnest_backend.dto.auth.RegisterRequest;
import com.footnest.footnest_backend.dto.auth.RegisterResponse;
import com.footnest.footnest_backend.service.AuthService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/auth")
@CrossOrigin
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }


    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

}