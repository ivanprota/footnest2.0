package com.footnest.footnest_backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.TeamCompetition;

public interface TeamCompetitionRepository extends JpaRepository<TeamCompetition, Long> {
    
    List<TeamCompetition> findByTeamId(Long teamId);

}
