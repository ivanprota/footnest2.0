package com.footnest.footnest_backend.controller;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.footnest.footnest_backend.dto.user.UserProfileDTO;
import com.footnest.footnest_backend.service.UserProfileService;


@RestController
@RequestMapping("/profile")
@CrossOrigin
public class ProfileController {

    private final UserProfileService userProfileService;

    public ProfileController(UserProfileService userProfileService) {
        this.userProfileService = userProfileService;
    }

    @GetMapping
    public UserProfileDTO getProfile(Authentication authentication) {
        return userProfileService
                .getProfile(authentication.getName());
    }

}