package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.config.AppConfig;
import com.footnest.footnest_backend.dto.team.MatchTeamStatisticsDTO;
import com.footnest.footnest_backend.dto.team.TeamMatchStatisticsDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.MatchStatistics;
import com.footnest.footnest_backend.repository.FootballMatchRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TeamStatisticsService {

    private final FootballMatchRepository footballMatchRepository;
    private final AppConfig appConfig;

    public List<TeamMatchStatisticsDTO> getStatistics(Long teamId) {

        List<FootballMatch> matches =
                footballMatchRepository
                        .findPlayedMatchesWithStatistics(teamId);

        return matches.stream()
                .map(match -> toDTO(match, teamId))
                .toList();
    }

    private TeamMatchStatisticsDTO toDTO(FootballMatch match, Long teamId) {

        MatchStatistics homeStatistics =
                match.getStatistics()
                        .stream()
                        .filter(s ->
                                s.getTeam().getId()
                                        .equals(match.getHomeTeam().getId())
                        )
                        .findFirst()
                        .orElse(null);

        MatchStatistics awayStatistics =
                match.getStatistics()
                        .stream()
                        .filter(s ->
                                s.getTeam().getId()
                                        .equals(match.getAwayTeam().getId())
                        )
                        .findFirst()
                        .orElse(null);

        return new TeamMatchStatisticsDTO(
                match.getId(),
                teamId,
                match.getHomeTeam().getId(),
                match.getAwayTeam().getId(),
                match.getDate(),
                match.getHomeTeam().getName(),
                match.getAwayTeam().getName(),
                appConfig.getBaseUrl() + "/uploads/" + match.getHomeTeam().getLogoPath(),
                appConfig.getBaseUrl() + "/uploads/" + match.getAwayTeam().getLogoPath(),
                match.getHomeGoals(),
                match.getAwayGoals(),
                toStatisticsDTO(homeStatistics),
                toStatisticsDTO(awayStatistics)
        );
    }

    private MatchTeamStatisticsDTO toStatisticsDTO(
            MatchStatistics statistics
    ) {

        if (statistics == null) {
            return null;
        }

        return new MatchTeamStatisticsDTO(
                statistics.getXg(),
                statistics.getPossession(),
                statistics.getTotalShots(),
                statistics.getShotsOnTarget(),
                statistics.getBigChances(),
                statistics.getCorners(),
                statistics.getYellowCards(),
                statistics.getRedCards(),
                statistics.getFouls()
        );
    }
}