package com.footnest.footnest_backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import com.footnest.footnest_backend.dto.team.TeamMatchStatisticsDTO;
import com.footnest.footnest_backend.service.TeamStatisticsService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/teams")
@CrossOrigin
@RequiredArgsConstructor
public class TeamStatisticsController {

    private final TeamStatisticsService teamStatisticsService;

    @GetMapping("/{teamId}/statistics")
    public List<TeamMatchStatisticsDTO> getStatistics(
            @PathVariable Long teamId
    ) {
        return teamStatisticsService.getStatistics(teamId);
    }
}