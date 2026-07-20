package com.footnest.footnest_backend.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.footnest.footnest_backend.dto.footballmatch.CompetitionMatchesDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.service.FootballMatchService;

@RestController
@RequestMapping("/football-matches")
@CrossOrigin
public class FootballMatchController {
    
    private final FootballMatchService footballMatchService;

    public FootballMatchController(FootballMatchService footballMatchService) {
        this.footballMatchService = footballMatchService;
    }

    @GetMapping
    public List<FootballMatch> getAll() {
        return footballMatchService.findAll();
    }

    @GetMapping("/{id}")
    public FootballMatch getById(@PathVariable Long id) {
        return footballMatchService.findById(id);
    }

    @GetMapping("/date/{date}")
    public List<CompetitionMatchesDTO> getByDate(@PathVariable LocalDate date) {
        return footballMatchService.findMatchesByDate(date);
    }

    @PostMapping
    public FootballMatch create(@RequestBody FootballMatch footballMatch) {
        return footballMatchService.save(footballMatch);
    }

    @PutMapping("/{id}")
    public FootballMatch update(@PathVariable Long id, @RequestBody FootballMatch footballMatch) {
        return footballMatchService.update(id, footballMatch);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        footballMatchService.delete(id);
    }

}
