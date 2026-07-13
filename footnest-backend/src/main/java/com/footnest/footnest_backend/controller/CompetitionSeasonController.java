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

import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.service.CompetitionSeasonService;

@RestController
@RequestMapping("/competition-seasons")
@CrossOrigin
public class CompetitionSeasonController {
    
    private final CompetitionSeasonService competitionSeasonService;

    public CompetitionSeasonController(CompetitionSeasonService competitionSeasonService) {
        this.competitionSeasonService = competitionSeasonService;
    }

    @GetMapping
    public List<CompetitionSeason> getAll() {
        return competitionSeasonService.findAll();
    }

    @GetMapping("/{id}")
    public CompetitionSeason getById(@PathVariable Long id) {
        return competitionSeasonService.findById(id);
    }

    @PostMapping
    public CompetitionSeason create(@RequestBody CompetitionSeason competitionSeason) {
        return competitionSeasonService.save(competitionSeason);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        competitionSeasonService.delete(id);
    }

}
