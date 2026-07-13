package com.footnest.footnest_backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.footnest.footnest_backend.entity.TeamCompetition;
import com.footnest.footnest_backend.service.TeamCompetitionService;

@RestController
@RequestMapping("/team-competitions")
@CrossOrigin
public class TeamCompetitionController {
    
    private final TeamCompetitionService teamCompetitionService;

    public TeamCompetitionController(TeamCompetitionService teamCompetitionService) {
        this.teamCompetitionService = teamCompetitionService;
    }

    @GetMapping
    public List<TeamCompetition> getAll() {
        return teamCompetitionService.findAll();
    }

    @GetMapping("/{id}")
    public TeamCompetition getById(@PathVariable Long id) {
        return teamCompetitionService.findById(id);
    }

    @PostMapping
    public TeamCompetition create(@RequestBody TeamCompetition teamCompetition) {
        return teamCompetitionService.save(teamCompetition);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        teamCompetitionService.delete(id);
    }

}
