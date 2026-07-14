package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.competitionseason.CompetitionSeasonDTO;
import com.footnest.footnest_backend.entity.CompetitionSeason;

@Component
public class CompetitionSeasonMapper {
    
    public CompetitionSeasonDTO toDTO(CompetitionSeason cs) {
        return new CompetitionSeasonDTO(
            cs.getId(),
            cs.getCompetition().getName(),
            cs.getSeason().getName()
        );
    }

}
