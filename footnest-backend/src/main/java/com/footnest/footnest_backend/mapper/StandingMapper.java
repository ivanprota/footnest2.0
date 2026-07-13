package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.standing.StandingDTO;
import com.footnest.footnest_backend.entity.Standing;


@Component
public class StandingMapper {

    private final TeamMapper teamMapper;

    StandingMapper(TeamMapper teamMapper) {
        this.teamMapper = teamMapper;
    }

    public StandingDTO toDTO(Standing standing, Integer position){
        StandingDTO dto = new StandingDTO();

        dto.setPosition(position);
        dto.setTeam(teamMapper.toDTO(standing.getTeam()));
        dto.setPlayed(standing.getPlayed());
        dto.setWins(standing.getWins());
        dto.setDraws(standing.getDraws());
        dto.setLosses(standing.getLosses());

        dto.setGoalsFor(standing.getGoalsFor());
        dto.setGoalsAgainst(standing.getGoalsAgainst());

        dto.setPoints(standing.getPoints());

        dto.setTotalXg(standing.getTotalXg());

        return dto;
    }

}
