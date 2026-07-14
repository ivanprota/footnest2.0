package com.footnest.footnest_backend.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.footnest.footnest_backend.dto.team.TeamCreateDTO;
import com.footnest.footnest_backend.dto.team.TeamDTO;
import com.footnest.footnest_backend.entity.Team;
import com.footnest.footnest_backend.service.TeamService;

@RestController
@RequestMapping("/teams")
@CrossOrigin
public class TeamController {
    
    private final TeamService teamService;

    public TeamController(TeamService teamService) {
        this.teamService = teamService;
    }

    @GetMapping
    public ResponseEntity<List<TeamDTO>> getAll() {
        return ResponseEntity.ok(teamService.findAll());
    }

    @GetMapping("/{id}")
    public Team getById(@PathVariable Long id) {
        return teamService.findById(id);
    }

    @PostMapping
    public ResponseEntity<TeamDTO> create(@RequestBody TeamCreateDTO dto) {
        return ResponseEntity.ok(teamService.save(dto));
    }

    @PutMapping("/{id}")
    public Team update(@PathVariable Long id, @RequestBody Team team) {
        return teamService.update(id, team);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        teamService.delete(id);
    }
}
