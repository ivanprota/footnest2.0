package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.mapper.StandingMapper;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.standing.StandingDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.MatchStatistics;
import com.footnest.footnest_backend.entity.MatchStatus;
import com.footnest.footnest_backend.entity.Standing;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.FootballMatchRepository;
import com.footnest.footnest_backend.repository.StandingRepository;

@Service
public class StandingService {
    
    private final StandingMapper standingMapper;
    private final StandingRepository standingRepository;
    private final FootballMatchRepository footballMatchRepository;

    public StandingService(
        StandingRepository standingRepository, 
        StandingMapper standingMapper, 
        FootballMatchRepository footballMatchRepository) 
    {
        this.standingRepository = standingRepository;
        this.standingMapper = standingMapper;
        this.footballMatchRepository = footballMatchRepository;
    }

    public List<Standing> findAll() {
        return standingRepository.findAll();
    }

    public Standing findById(Long id) {
        return standingRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Dati squadra per classifica non trovati con id: " +id));
    }

    public List<StandingDTO> getByCompetitionSeason(
            Long competitionSeasonId
    ) {

        List<Standing> standings =
                standingRepository
                        .findByCompetitionSeasonIdOrderByPointsDesc(
                                competitionSeasonId
                        );

        List<FootballMatch> matches =
                footballMatchRepository
                        .findByCompetitionSeasonIdAndStatus(
                                competitionSeasonId,
                                MatchStatus.PLAYED
                        );

        int position = 1;

        List<StandingDTO> result = new ArrayList<>();

        for (Standing standing : standings) {

            List<String> form =
                    calculateForm(
                            standing.getTeam().getId(),
                            matches
                    );

            result.add(
                    standingMapper.toDTO(
                            standing,
                            position,
                            form
                    )
            );

            position++;
        }

        return result;
    }

    public Standing save(Standing standing) {
        return standingRepository.save(standing);
    }

    public Standing update(Long id, Standing standing) {
        Standing existing = findById(id);

        existing.setPlayed(standing.getPlayed());
        existing.setWins(standing.getWins());
        existing.setDraws(standing.getDraws());
        existing.setLosses(standing.getLosses());
        existing.setGoalsFor(standing.getGoalsFor());
        existing.setGoalsAgainst(standing.getGoalsAgainst());
        existing.setPoints(standing.getPoints());
        existing.setTotalXg(standing.getTotalXg());

        return standingRepository.save(existing);
    }

    public void delete(Long id) {
        if (!standingRepository.existsById(id)) {
            throw new ResourceNotFoundException("Dati squadra per classifica non trovati con id: " +id);
        }

        standingRepository.deleteById(id);
    }

    public void recalculateStandings(Long competitionSeasonId) {
        List<Standing> standings = standingRepository.findByCompetitionSeasonId(competitionSeasonId);
        for (Standing standing : standings) {

            standing.setPlayed(0);

            standing.setWins(0);
            standing.setDraws(0);
            standing.setLosses(0);

            standing.setGoalsFor(0);
            standing.setGoalsAgainst(0);

            standing.setPoints(0);

            standing.setTotalXg(0.0);
        }

        List<FootballMatch> matches =
                footballMatchRepository
                        .findByCompetitionSeasonIdAndStatus(
                                competitionSeasonId,
                                MatchStatus.PLAYED
                        );

        for (FootballMatch match : matches) {

            Standing homeStanding =
                    standings.stream()
                            .filter(s ->
                                    s.getTeam().getId().equals(
                                            match.getHomeTeam().getId()))
                            .findFirst()
                            .orElseThrow();

            Standing awayStanding =
                    standings.stream()
                            .filter(s ->
                                    s.getTeam().getId().equals(
                                            match.getAwayTeam().getId()))
                            .findFirst()
                            .orElseThrow();

            updateStanding(
                    homeStanding,
                    awayStanding,
                    match
            );
        }

        standingRepository.saveAll(standings);
    }

    private void updateStanding(Standing home, Standing away, FootballMatch match) {

        int homeGoals = match.getHomeGoals();
        int awayGoals = match.getAwayGoals();

        home.setPlayed(home.getPlayed() + 1);
        away.setPlayed(away.getPlayed() + 1);

        home.setGoalsFor(home.getGoalsFor() + homeGoals);
        home.setGoalsAgainst(home.getGoalsAgainst() + awayGoals);

        away.setGoalsFor(away.getGoalsFor() + awayGoals);
        away.setGoalsAgainst(away.getGoalsAgainst() + homeGoals);

        if(homeGoals > awayGoals) {
            home.setWins(home.getWins() + 1);
            away.setLosses(away.getLosses() + 1);
            home.setPoints(home.getPoints() + 3);
        } 
        else if(homeGoals < awayGoals) {
            away.setWins(away.getWins() + 1);
            home.setLosses(home.getLosses() + 1);
            away.setPoints(away.getPoints() + 3);
        } 
        else {
            home.setDraws(home.getDraws() + 1);
            away.setDraws(away.getDraws() + 1);
            home.setPoints(home.getPoints() + 1);
            away.setPoints(away.getPoints() + 1);
        }

        if (match.getStatistics() != null) {

            for (MatchStatistics stat : match.getStatistics()) {

                if (stat.getXg() == null) {
                    continue;
                }


                if (stat.getTeam().getId()
                        .equals(home.getTeam().getId())) {

                    home.setTotalXg(
                            home.getTotalXg()
                                + stat.getXg()
                    );

                }


                if (stat.getTeam().getId()
                        .equals(away.getTeam().getId())) {

                    away.setTotalXg(
                            away.getTotalXg()
                                + stat.getXg()
                    );

                }

            }
        }

    }

    private List<String> calculateForm(
            Long teamId,
            List<FootballMatch> matches
    ) {

        return matches.stream()

                // Solo le partite della squadra
                .filter(match ->
                        match.getHomeTeam().getId().equals(teamId)
                        ||
                        match.getAwayTeam().getId().equals(teamId)
                )

                // Dalla più recente alla più vecchia
                .sorted(
                        (a, b) -> {

                            int dateComparison =
                                    b.getDate().compareTo(a.getDate());

                            if (dateComparison != 0) {
                                return dateComparison;
                            }

                            if (a.getKickoffTime() == null
                                    && b.getKickoffTime() == null) {
                                return 0;
                            }

                            if (a.getKickoffTime() == null) {
                                return 1;
                            }

                            if (b.getKickoffTime() == null) {
                                return -1;
                            }

                            return b.getKickoffTime()
                                    .compareTo(a.getKickoffTime());
                        }
                )

                // Massimo ultime 5
                .limit(5)

                // V / S / P
                .map(match -> {

                    boolean isHome =
                            match.getHomeTeam()
                                    .getId()
                                    .equals(teamId);

                    int teamGoals =
                            isHome
                                    ? match.getHomeGoals()
                                    : match.getAwayGoals();

                    int opponentGoals =
                            isHome
                                    ? match.getAwayGoals()
                                    : match.getHomeGoals();

                    if (teamGoals > opponentGoals) {
                        return "V";
                    }

                    if (teamGoals < opponentGoals) {
                        return "S";
                    }

                    return "P";
                })

                .toList();
    }

}
