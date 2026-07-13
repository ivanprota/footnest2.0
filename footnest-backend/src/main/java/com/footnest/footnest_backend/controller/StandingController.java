package com.footnest.footnest_backend.controller;

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

import com.footnest.footnest_backend.dto.standing.StandingDTO;
import com.footnest.footnest_backend.entity.Standing;
import com.footnest.footnest_backend.service.StandingService;

@RestController
@RequestMapping("/standings")
@CrossOrigin
public class StandingController {
    
    private final StandingService standingService;

    public StandingController(StandingService standingService) {
        this.standingService = standingService;
    }

    @GetMapping
    public List<Standing> getAll() {
        return standingService.findAll();
    }

    @GetMapping("/{id}")
    public Standing getById(@PathVariable Long id) {
        return standingService.findById(id);
    }

    @GetMapping("/competition-season/{id}")
    public List<StandingDTO> getByCompetitionSeason(@PathVariable Long id) {
        return standingService.getByCompetitionSeason(id);
    }

    @PostMapping
    public Standing create(@RequestBody Standing standing) {
        return standingService.save(standing);
    }

    @PutMapping("/{id}")
    public Standing update(@PathVariable Long id, @RequestBody Standing standing) {
        return standingService.update(id, standing);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        standingService.delete(id);
    }

}
