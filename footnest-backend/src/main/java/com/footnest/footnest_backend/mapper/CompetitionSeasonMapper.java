package com.footnest.footnest_backend.mapper;

import java.util.List;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.config.AppConfig;
import com.footnest.footnest_backend.dto.competitionseason.CompetitionSeasonDTO;
import com.footnest.footnest_backend.dto.footballmatch.CompetitionMatchesDTO;
import com.footnest.footnest_backend.dto.footballmatch.MatchSummaryDTO;
import com.footnest.footnest_backend.entity.CompetitionSeason;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class CompetitionSeasonMapper {
    
    private final AppConfig appConfig;

    public CompetitionSeasonDTO toDTO(CompetitionSeason cs) {
        return new CompetitionSeasonDTO(
            cs.getId(),
            cs.getCompetition().getName(),
            cs.getSeason().getName()
        );
    }

    public CompetitionMatchesDTO toMatchesDTO (CompetitionSeason cs, List<MatchSummaryDTO> matches) {
        return new CompetitionMatchesDTO(
            cs.getId(),
            cs.getCompetition().getName(),
            appConfig.getBaseUrl()
                + "/uploads/"
                + cs.getCompetition().getLogoPath(),
            matches
        );
    }

}
