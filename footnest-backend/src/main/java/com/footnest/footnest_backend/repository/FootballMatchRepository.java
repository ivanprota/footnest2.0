package com.footnest.footnest_backend.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.Team;

public interface FootballMatchRepository extends JpaRepository<FootballMatch, Long> {
    
    @Query("""
        SELECT m
        FROM FootballMatch m
        WHERE (m.homeTeam.id = :teamId OR m.awayTeam.id = :teamId)
        AND m.status = 'PLAYED'
        ORDER BY m.date DESC
    """)
    List<FootballMatch> findLastMatches(
            @Param("teamId") Long teamId,
            Pageable pageable
    );



    @Query("""
        SELECT m
        FROM FootballMatch m
        WHERE (m.homeTeam.id = :teamId OR m.awayTeam.id = :teamId)
        AND m.status = 'SCHEDULED'
        ORDER BY m.date ASC
    """)
    List<FootballMatch> findNextMatches(
            @Param("teamId") Long teamId,
            Pageable pageable
    );

    boolean existsByDateAndHomeTeamAndAwayTeam(
            LocalDate date,
            Team homeTeam,
            Team awayTeam
    );

    @Query("""
        SELECT m
        FROM FootballMatch m
        JOIN FETCH m.homeTeam
        JOIN FETCH m.awayTeam
        JOIN FETCH m.competitionSeason cs
        JOIN FETCH cs.competition
        WHERE m.date = :date
        ORDER BY cs.competition.name, m.id
    """)
    List<FootballMatch> findMatchesByDate(@Param("date") LocalDate date);

}
