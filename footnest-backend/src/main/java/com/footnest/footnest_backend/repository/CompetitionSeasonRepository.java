package com.footnest.footnest_backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Competition;
import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.entity.Season;

public interface CompetitionSeasonRepository extends JpaRepository<CompetitionSeason, Long> {
    
    Optional<CompetitionSeason> findByCompetitionAndSeason(Competition competition, Season season);

}
