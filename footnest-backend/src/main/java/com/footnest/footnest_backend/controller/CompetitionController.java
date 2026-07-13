package com.footnest.footnest_backend.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.footnest.footnest_backend.dto.competition.CompetitionDTO;
import com.footnest.footnest_backend.dto.competition.CompetitionDetailsDTO;
import com.footnest.footnest_backend.entity.Competition;
import com.footnest.footnest_backend.service.CompetitionService;

@RestController
@RequestMapping("/competitions")
@CrossOrigin
public class CompetitionController {
    
    private final CompetitionService competitionService;

    public CompetitionController(CompetitionService competitionService) {
        this.competitionService = competitionService;
    }

    @GetMapping
    public ResponseEntity<List<CompetitionDTO>> getAll() {
        return ResponseEntity.ok(competitionService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<CompetitionDetailsDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(competitionService.findDetailsById(id));
    }

    @PostMapping
    public Competition create(@RequestBody Competition competition) {
        return competitionService.save(competition);
    }

    // @PutMapping("/{id}")
    // public Competition update(@PathVariable Long id, @RequestBody Competition competition) {
    //     return competitionService.update(id, competition);
    // }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        competitionService.delete(id);
    }

}
