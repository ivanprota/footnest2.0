package com.footnest.footnest_backend.security;

import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.repository.UserRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import org.springframework.security.core.userdetails.UserDetails;

import org.springframework.stereotype.Component;

import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;


@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {


    private final JwtService jwtService;

    private final CustomUserDetailsService userDetailsService;

    private final UserRepository userRepository;


    public JwtAuthenticationFilter(
            JwtService jwtService,
            CustomUserDetailsService userDetailsService,
            UserRepository userRepository
    ) {
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
        this.userRepository = userRepository;
    }



    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {


        String header = request.getHeader("Authorization");


        if (header == null || !header.startsWith("Bearer ")) {

            filterChain.doFilter(request, response);
            return;
        }


        String token = header.substring(7);


        String username;


        try {

            username = jwtService.extractUsername(token);

        } catch (Exception e) {

            filterChain.doFilter(request, response);
            return;
        }



        if (username != null &&
                SecurityContextHolder
                        .getContext()
                        .getAuthentication() == null) {


            User user = userRepository.findByUsername(username)
                    .orElse(null);


            if (user != null &&
                    jwtService.isValid(token, user)) {


                UserDetails userDetails =
                        userDetailsService
                                .loadUserByUsername(username);



                UsernamePasswordAuthenticationToken auth =
                        new UsernamePasswordAuthenticationToken(
                                userDetails,
                                null,
                                userDetails.getAuthorities()
                        );


                SecurityContextHolder
                        .getContext()
                        .setAuthentication(auth);
            }

        }


        filterChain.doFilter(request, response);

    }

}