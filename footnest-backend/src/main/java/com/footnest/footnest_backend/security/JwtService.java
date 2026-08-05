package com.footnest.footnest_backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.User;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;

@Service
public class JwtService {

    private static final String SECRET_KEY =
            "footnest-secret-key-super-long-for-jwt-security-2026";

    private final SecretKey key =
            Keys.hmacShaKeyFor(SECRET_KEY.getBytes(StandardCharsets.UTF_8));

    private final long expiration = 1000 * 60 * 60 * 24; // 24 ore

    public String generateToken(User user) {
        return Jwts.builder()
                .subject(user.getUsername())
                .claim("admin", user.isAdmin())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(key)
                .compact();
    }

    public String extractUsername(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getSubject();
    }

    public boolean isValid(String token, User user) {
        String username = extractUsername(token);
        return username.equals(user.getUsername())
                && !isExpired(token);
    }

    private boolean isExpired(String token) {
        Date expiration =
                Jwts.parser()
                .verifyWith((javax.crypto.SecretKey) key)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getExpiration();

        return expiration.before(new Date());
    }
}
