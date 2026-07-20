package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.footballmatch.MatchSummaryDTO;
import com.footnest.footnest_backend.entity.FootballMatch;

@Component
public class FootballMatchMapper {

    public MatchSummaryDTO toSummaryDTO(FootballMatch match) {

        return new MatchSummaryDTO(
                match.getId(),
                match.getHomeTeam().getName(),
                match.getAwayTeam().getName(),
                match.getHomeTeam().getLogoPath(),
                match.getAwayTeam().getLogoPath(),
                match.getDate(),
                match.getKickoffTime(),
                match.getHomeGoals(),
                match.getAwayGoals(),
                match.getMatchday(),
                match.getStatus().name()
        );
    }

}
