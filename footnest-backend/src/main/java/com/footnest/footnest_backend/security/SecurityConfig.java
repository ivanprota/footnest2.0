package com.footnest.footnest_backend.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(
            JwtAuthenticationFilter jwtAuthenticationFilter
    ) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable()).authorizeHttpRequests(auth -> auth

                .requestMatchers(
                    "/auth/**",
                    "/uploads/**"
                ).permitAll()

                .requestMatchers(
                    org.springframework.http.HttpMethod.PUT,
                    "/users/*/approval"
                ).hasRole("ADMIN")

                .requestMatchers(
                    org.springframework.http.HttpMethod.DELETE,
                    "/users/**"
                ).hasRole("ADMIN")

                .requestMatchers(
                    org.springframework.http.HttpMethod.POST,
                    "/competitions/**"
                ).hasRole("ADMIN")

                .requestMatchers(
                    org.springframework.http.HttpMethod.DELETE,
                    "/competitions/**"
                ).hasRole("ADMIN")

                .requestMatchers(
                    "/users/**"
                ).authenticated()

                .anyRequest()
                .authenticated()
            )

            .addFilterBefore(
                jwtAuthenticationFilter,
                UsernamePasswordAuthenticationFilter.class
            );

        return http.build();
    }
}