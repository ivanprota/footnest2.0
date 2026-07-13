package com.footnest.footnest_backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Standing;

public interface StandingRepository extends JpaRepository<Standing, Long> {
    
    Optional<Standing> findByTeamId(Long teamId);

    List<Standing> findByCompetitionSeasonIdOrderByPointsDesc(Long competitionSeasonId);

    Optional<Standing> findByTeamIdAndCompetitionSeasonId(
            Long teamId,
            Long competitionSeasonId
    );

}
