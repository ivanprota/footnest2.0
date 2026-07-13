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

import com.footnest.footnest_backend.entity.MatchStatistics;
import com.footnest.footnest_backend.service.MatchStatisticsService;

@RestController
@RequestMapping("/matches-statistics")
@CrossOrigin
public class MatchStatisticsController {
    
    private final MatchStatisticsService matchStatisticsService;

    public MatchStatisticsController(MatchStatisticsService matchStatisticsService) {
        this.matchStatisticsService = matchStatisticsService;
    }

    @GetMapping
    public List<MatchStatistics> getAll() {
        return matchStatisticsService.findAll();
    }

    @GetMapping("/{id}")
    public MatchStatistics getById(@PathVariable Long id) {
        return matchStatisticsService.findById(id);
    }

    @PostMapping
    public MatchStatistics create(@RequestBody MatchStatistics matchStatistics) {
        return matchStatisticsService.save(matchStatistics);
    }

    @PutMapping("/{id}")
    public MatchStatistics update(@PathVariable Long id, @RequestBody MatchStatistics matchStatistics) {
        return matchStatisticsService.update(id, matchStatistics);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        matchStatisticsService.delete(id);
    }

}
