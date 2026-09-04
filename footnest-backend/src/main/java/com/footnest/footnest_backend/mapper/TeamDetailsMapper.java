package com.footnest.footnest_backend.mapper;

import java.util.List;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.footballmatch.MatchSummaryDTO;
import com.footnest.footnest_backend.dto.standing.StandingDTO;
import com.footnest.footnest_backend.dto.teamcompetition.TeamCompetitionDTO;
import com.footnest.footnest_backend.dto.team.TeamDTO;
import com.footnest.footnest_backend.dto.team.TeamDetailsDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.Standing;
import com.footnest.footnest_backend.entity.Team;

import lombok.RequiredArgsConstructor;


@Component
@RequiredArgsConstructor
public class TeamDetailsMapper {

    private final TeamMapper teamMapper;
    private final StandingMapper standingMapper;
    private final MatchSummaryMapper matchSummaryMapper;

    public TeamDetailsDTO toDTO(
            Team team,
            List<TeamCompetitionDTO> competitions,
            Standing standing,
            Integer position,
            List<FootballMatch> lastMatches,
            List<FootballMatch> nextMatches
    ) {
        TeamDTO teamDTO = teamMapper.toDTO(team);
        TeamDetailsDTO dto = new TeamDetailsDTO();

        dto.setId(teamDTO.getId());
        dto.setName(teamDTO.getName());
        dto.setLogoPath(teamDTO.getLogoPath());
        dto.setCompetitions(competitions);

        List<String> form = lastMatches.stream()
                .map(match -> {

                    boolean isHome =
                            match.getHomeTeam().getId()
                            .equals(team.getId());

                    int teamGoals = isHome
                            ? match.getHomeGoals()
                            : match.getAwayGoals();

                    int opponentGoals = isHome
                            ? match.getAwayGoals()
                            : match.getHomeGoals();

                    if (teamGoals > opponentGoals) {
                        return "V";
                    }

                    if (teamGoals < opponentGoals) {
                        return "S";
                    }

                    return "P";
                }).toList();

        if (standing != null) {
            StandingDTO standingDTO = standingMapper.toDTO(standing, position, form);
            dto.setStanding(standingDTO);
        }

        List<MatchSummaryDTO> lastMatchDTOs =
                lastMatches.stream()
                        .map(matchSummaryMapper::toDTO)
                        .toList();

        List<MatchSummaryDTO> nextMatchDTOs =
                nextMatches.stream()
                        .map(matchSummaryMapper::toDTO)
                        .toList();

        dto.setLastMatches(lastMatchDTOs);
        dto.setNextMatches(nextMatchDTOs);
        
        return dto;
    }

}
