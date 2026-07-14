package com.footnest.footnest_backend.service;

import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.footnest.footnest_backend.dto.team.TeamCreateDTO;
import com.footnest.footnest_backend.dto.team.TeamDTO;
import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.entity.Standing;
import com.footnest.footnest_backend.entity.Team;
import com.footnest.footnest_backend.entity.TeamCompetition;
import com.footnest.footnest_backend.exception.DuplicateResourceException;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.mapper.TeamMapper;
import com.footnest.footnest_backend.repository.CompetitionSeasonRepository;
import com.footnest.footnest_backend.repository.StandingRepository;
import com.footnest.footnest_backend.repository.TeamCompetitionRepository;
import com.footnest.footnest_backend.repository.TeamRepository;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class TeamRegistrationService {


    private final TeamRepository teamRepository;
    private final CompetitionSeasonRepository competitionSeasonRepository;
    private final TeamCompetitionRepository teamCompetitionRepository;
    private final StandingRepository standingRepository;
    private final TeamMapper teamMapper;


    @Transactional
    public TeamDTO register(TeamCreateDTO dto) {
        CompetitionSeason competitionSeason =
                competitionSeasonRepository.findById(dto.getCompetitionSeasonId())
                .orElseThrow(() ->
                    new ResourceNotFoundException(
                        "CompetitionSeason non trovata con id: "
                        + dto.getCompetitionSeasonId()
                    )
                );

        Team team = teamRepository.findByName(dto.getName())
                .orElseGet(() -> {
                    Team newTeam = new Team();
                    newTeam.setName(dto.getName());
                    newTeam.setLogoPath(dto.getLogoPath());

                    return teamRepository.save(newTeam);
                });

        Optional<TeamCompetition> existingParticipation =
                teamCompetitionRepository
                    .findByTeamIdAndCompetitionSeasonId(
                        team.getId(),
                        competitionSeason.getId()
                    );

        if(existingParticipation.isPresent()) {
            throw new DuplicateResourceException(
                "La squadra è già iscritta a questa competizione"
            );
        }

        TeamCompetition teamCompetition = new TeamCompetition();
        teamCompetition.setTeam(team);
        teamCompetition.setCompetitionSeason(competitionSeason);
        teamCompetition.setSeason(competitionSeason.getSeason());

        teamCompetitionRepository.save(teamCompetition);

        Standing standing = new Standing();
        standing.setTeam(team);
        standing.setCompetitionSeason(competitionSeason);
        standing.setPlayed(0);
        standing.setWins(0);
        standing.setDraws(0);
        standing.setLosses(0);
        standing.setGoalsFor(0);
        standing.setGoalsAgainst(0);
        standing.setPoints(0);
        standing.setTotalXg(0.0);

        standingRepository.save(standing);

        return teamMapper.toDTO(team);
    }
}