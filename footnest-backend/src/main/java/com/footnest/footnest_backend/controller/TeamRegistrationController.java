package com.footnest.footnest_backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.footnest.footnest_backend.dto.team.TeamCreateDTO;
import com.footnest.footnest_backend.dto.team.TeamDTO;
import com.footnest.footnest_backend.service.TeamRegistrationService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/teams")
@RequiredArgsConstructor
@CrossOrigin
public class TeamRegistrationController {

    private final TeamRegistrationService teamRegistrationService;

    @PostMapping("/register")
    public ResponseEntity<TeamDTO> register(@RequestBody TeamCreateDTO dto) {
        return ResponseEntity.ok(teamRegistrationService.register(dto));
    }

}