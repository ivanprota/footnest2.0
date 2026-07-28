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

import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsCreateDTO;
import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsDTO;
import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsUpdateDTO;
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
    public List<MatchStatisticsDTO> getAll() {
        return matchStatisticsService.findAll();
    }

    @GetMapping("/{id}")
    public MatchStatisticsDTO getById(@PathVariable Long id) {
        return matchStatisticsService.findById(id);
    }

    @PostMapping
    public MatchStatisticsDTO create(@RequestBody MatchStatisticsCreateDTO dto) {
        return matchStatisticsService.create(dto);
    }

    @PutMapping("/{id}")
    public MatchStatisticsDTO update(@PathVariable Long id, @RequestBody MatchStatisticsUpdateDTO dto) {
        return matchStatisticsService.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        matchStatisticsService.delete(id);
    }

}
