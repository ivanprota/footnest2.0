package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.team.TeamDetailsDTO;
import com.footnest.footnest_backend.dto.teamcompetition.TeamCompetitionDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.Standing;
import com.footnest.footnest_backend.entity.Team;
import com.footnest.footnest_backend.entity.TeamCompetition;
import com.footnest.footnest_backend.mapper.TeamDetailsMapper;
import com.footnest.footnest_backend.repository.FootballMatchRepository;
import com.footnest.footnest_backend.repository.StandingRepository;
import com.footnest.footnest_backend.repository.TeamCompetitionRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TeamDetailsService {

    private final TeamService teamService;
    private final TeamCompetitionRepository teamCompetitionRepository;
    private final StandingRepository standingRepository;
    private final FootballMatchRepository footballMatchRepository;
    private final TeamDetailsMapper teamDetailsMapper;

    public TeamDetailsDTO getDetails(Long teamId){
        Team team = teamService.findById(teamId);
        List<TeamCompetition> competitions = teamCompetitionRepository.findByTeamId(teamId);
        TeamCompetition currentCompetition = competitions.get(0);
        Long competitionSeasonId = currentCompetition.getCompetitionSeason().getId();
        List<TeamCompetitionDTO> competitionDTOs =
                competitions.stream()
                    .map(tc -> new TeamCompetitionDTO(
                            tc.getCompetitionSeason()
                              .getCompetition()
                              .getName(),

                            tc.getCompetitionSeason()
                              .getSeason()
                              .getName()
                    ))
                    .toList();

        List<FootballMatch> lastMatches =
                footballMatchRepository.findLastMatches(
                        teamId,
                        PageRequest.of(0,5)
                );

        List<FootballMatch> nextMatches =
                footballMatchRepository.findNextMatches(
                        teamId,
                        PageRequest.of(0,5)
                );

        List<Standing> standings = standingRepository
                .findByCompetitionSeasonIdOrderByPointsDesc(competitionSeasonId);

        Standing standing = null;
        Integer position = null;
        int index = 1;

        for (Standing s : standings) {
                if (s.getTeam().getId().equals(teamId)) {
                        standing = s;
                        position = index;
                        break;
                }
                index++;
        }

        return teamDetailsMapper.toDTO(
                team,
                competitionDTOs,
                standing,
                position,
                lastMatches,
                nextMatches
        );

    }
}
