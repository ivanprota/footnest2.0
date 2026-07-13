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

import com.footnest.footnest_backend.entity.Season;
import com.footnest.footnest_backend.service.SeasonService;

@RestController
@RequestMapping("/seasons")
@CrossOrigin
public class SeasonController {
    
    private final SeasonService seasonService;

    public SeasonController(SeasonService seasonService) {
        this.seasonService = seasonService;
    }

    @GetMapping
    public List<Season> getAll() {
        return seasonService.findAll();
    }

    @GetMapping("/{id}")
    public Season getById(@PathVariable Long id) {
        return seasonService.findById(id);
    }

    @PostMapping
    public Season create(@RequestBody Season season) {
        return seasonService.save(season);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        seasonService.delete(id);
    }

}
