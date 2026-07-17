package com.footnest.footnest_backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.entity.Team;
import com.footnest.footnest_backend.entity.TeamCompetition;

public interface TeamCompetitionRepository extends JpaRepository<TeamCompetition, Long> {
    
    List<TeamCompetition> findByTeamId(Long teamId);
    Optional<TeamCompetition> findByTeamIdAndCompetitionSeasonId(
            Long teamId,
            Long competitionSeasonId
    );

    boolean existsByTeamAndCompetitionSeason(
            Team team,
            CompetitionSeason competitionSeason
    );

}
