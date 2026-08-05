package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.dto.auth.LoginRequest;
import com.footnest.footnest_backend.dto.auth.RegisterRequest;
import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.repository.UserRepository;
import com.footnest.footnest_backend.security.JwtService;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.auth.AuthResponse;


@Service
public class AuthService {


    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final JwtService jwtService;

    public AuthService(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService
    ) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }


    public User register(RegisterRequest request) {

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username già utilizzato");
        }


        User user = new User();

        user.setUsername(request.getUsername());

        user.setPasswordHash(
                passwordEncoder.encode(request.getPassword())
        );

        user.setApproved(false);

        user.setAdmin(false);


        return userRepository.save(user);
    }


    public AuthResponse login(LoginRequest request) {


        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() ->
                        new RuntimeException("Credenziali non valide")
                );


        if (!passwordEncoder.matches(
                request.getPassword(),
                user.getPasswordHash()
        )) {
            throw new RuntimeException("Credenziali non valide");
        }


        if (!user.isApproved()) {
            throw new RuntimeException("Account non ancora approvato");
        }

        return new AuthResponse(
                jwtService.generateToken(user),
                user.getUsername(),
                user.isAdmin()
        );
    }

}
