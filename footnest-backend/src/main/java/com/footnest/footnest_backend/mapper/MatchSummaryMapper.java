package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.config.AppConfig;
import com.footnest.footnest_backend.dto.footballmatch.MatchSummaryDTO;
import com.footnest.footnest_backend.entity.FootballMatch;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class MatchSummaryMapper {

    private final AppConfig appConfig;

    public MatchSummaryDTO toDTO(FootballMatch match){
        MatchSummaryDTO dto = new MatchSummaryDTO();

        dto.setId(match.getId());
        dto.setHomeTeam(
            match.getHomeTeam().getName()
        );
        dto.setAwayTeam(
            match.getAwayTeam().getName()
        );
        dto.setHomeLogo(
            appConfig.getBaseUrl()
            + "/uploads/"
            + match.getHomeTeam().getLogoPath()
        );
        dto.setAwayLogo(
            appConfig.getBaseUrl()
            + "/uploads/"
            + match.getAwayTeam().getLogoPath()
        );
        dto.setDate(match.getDate());
        dto.setHomeGoals(match.getHomeGoals());
        dto.setAwayGoals(match.getAwayGoals());
        dto.setStatus(
            match.getStatus().name()
        );
        return dto;
    }

}
