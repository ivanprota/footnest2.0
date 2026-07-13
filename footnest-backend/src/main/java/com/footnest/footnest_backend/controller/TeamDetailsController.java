package com.footnest.footnest_backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.footnest.footnest_backend.dto.team.TeamDetailsDTO;
import com.footnest.footnest_backend.service.TeamDetailsService;

import lombok.RequiredArgsConstructor;


@RestController
@RequestMapping("/teams")
@RequiredArgsConstructor
@CrossOrigin
public class TeamDetailsController {

    private final TeamDetailsService teamDetailsService;

    @GetMapping("/{id}/details")
    public ResponseEntity<TeamDetailsDTO> getDetails(@PathVariable Long id) {
        TeamDetailsDTO dto = teamDetailsService.getDetails(id);
        return ResponseEntity.ok(dto);
    }

}