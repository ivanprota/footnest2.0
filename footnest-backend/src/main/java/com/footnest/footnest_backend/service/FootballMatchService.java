package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.mapper.MatchSummaryMapper;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.footballmatch.CompetitionMatchesDTO;
import com.footnest.footnest_backend.dto.footballmatch.MatchDetailDTO;
import com.footnest.footnest_backend.dto.footballmatch.MatchSummaryDTO;
import com.footnest.footnest_backend.dto.footballmatch.UpdateMatchRequest;
import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsDTO;
import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.MatchStatus;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.mapper.CompetitionSeasonMapper;
import com.footnest.footnest_backend.mapper.FootballMatchMapper;
import com.footnest.footnest_backend.mapper.MatchStatisticsMapper;
import com.footnest.footnest_backend.repository.FootballMatchRepository;

@Service
public class FootballMatchService {
    
    private final MatchSummaryMapper matchSummaryMapper;
    private final FootballMatchRepository footballMatchRepository;
    private final FootballMatchMapper footballMatchMapper;
    private final CompetitionSeasonMapper competitionSeasonMapper;
    private final MatchStatisticsMapper matchStatisticsMapper;
    private final StandingService standingService;

    public FootballMatchService(
        FootballMatchRepository footballMatchRepository, 
        FootballMatchMapper footballMatchMapper,
        CompetitionSeasonMapper competitionSeasonMapper,
        MatchStatisticsMapper matchStatisticsMapper,
        StandingService standingService, MatchSummaryMapper matchSummaryMapper) {
        this.footballMatchRepository = footballMatchRepository;
        this.footballMatchMapper = footballMatchMapper;
        this.competitionSeasonMapper = competitionSeasonMapper;
        this.matchStatisticsMapper = matchStatisticsMapper;
        this.standingService = standingService;
        this.matchSummaryMapper = matchSummaryMapper;
    }

    public List<FootballMatch> findAll() {
        return footballMatchRepository.findAll();
    }

    public FootballMatch findById(Long id) {
        return footballMatchRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Match non trovato con id: " +id));
    }

    public List<CompetitionMatchesDTO> findMatchesByDate(LocalDate date) {
        List<FootballMatch> matches = footballMatchRepository.findMatchesByDate(date);
        Map<CompetitionSeason, List<FootballMatch>> grouped =
                matches.stream()
                        .collect(Collectors.groupingBy(
                                FootballMatch::getCompetitionSeason,
                                LinkedHashMap::new,
                                Collectors.toList()
                        ));

        List<CompetitionMatchesDTO> result = new ArrayList<>();

        for (Map.Entry<CompetitionSeason, List<FootballMatch>> entry : grouped.entrySet()) {
            List<MatchSummaryDTO> matchDTOs =
                    entry.getValue()
                            .stream()
                            .map(footballMatchMapper::toSummaryDTO)
                            .toList();

            result.add(
                    competitionSeasonMapper.toMatchesDTO(
                            entry.getKey(),
                            matchDTOs
                    )
            );
        }

        return result;
    }

    public MatchDetailDTO getMatchDetail(Long id) {
        FootballMatch match = footballMatchRepository.findById(id)
                .orElseThrow(() -> 
                    new ResourceNotFoundException("Partita non trovata")
                );


        List<MatchStatisticsDTO> statistics =
                match.getStatistics()
                .stream()
                .map(matchStatisticsMapper::toDTO)
                .toList();

        return new MatchDetailDTO(
                match.getId(),
                match.getHomeTeam().getId(),
                match.getAwayTeam().getId(),
                match.getHomeTeam().getName(),
                match.getAwayTeam().getName(),
                match.getHomeTeam().getLogoPath(),
                match.getAwayTeam().getLogoPath(),
                match.getDate(),
                match.getKickoffTime(),
                match.getHomeGoals(),
                match.getAwayGoals(),
                match.getMatchday(),
                match.getStatus().name(),
                match.getCompetitionSeason().getCompetition().getName(),
                match.getSeason().getName(),
                statistics
        );
    }

    public List<MatchSummaryDTO> findMatchesByCompetitionSeason(
            Long competitionSeasonId
    ) {

        return footballMatchRepository
                .findByCompetitionSeasonIdOrderByMatchdayAscDateAsc(
                        competitionSeasonId
                )
                .stream()
                .map(matchSummaryMapper::toDTO)
                .toList();
    }

    public FootballMatch save(FootballMatch footballMatch) {
        return footballMatchRepository.save(footballMatch);
    }

    public FootballMatch update(Long id, FootballMatch footballMatch) {
        FootballMatch existing = findById(id);

        existing.setHomeGoals(footballMatch.getHomeGoals());
        existing.setAwayGoals(footballMatch.getAwayGoals());
        existing.setKickoffTime(footballMatch.getKickoffTime());

        return footballMatchRepository.save(existing);
    }

    public MatchDetailDTO updateMatch(Long id, UpdateMatchRequest request) {
        FootballMatch match =
                footballMatchRepository.findById(id)
                .orElseThrow(() ->
                    new ResourceNotFoundException(
                        "Partita non trovata"
                    )
                );

        if (request.getDate() != null) {
            match.setDate(request.getDate());
        }

        if (request.getKickoffTime() != null) {
            match.setKickoffTime(request.getKickoffTime());
        }

        if (request.getHomeGoals() != null) {
            match.setHomeGoals(request.getHomeGoals());
        }

        if (request.getAwayGoals() != null) {
            match.setAwayGoals(request.getAwayGoals());
        }

        if (request.getStatus() != null) {
            match.setStatus(request.getStatus());
        }

        // Se entrambe le squadre hanno un risultato valido,
        // la partita viene automaticamente segnata come PLAYED.
        boolean played =
                match.getHomeGoals() != null
                && match.getAwayGoals() != null
                && match.getHomeGoals() != -1
                && match.getAwayGoals() != -1;

        if (played) {
            match.setStatus(MatchStatus.PLAYED);
        } else if (match.getStatus() == MatchStatus.PLAYED) {
            // Se il risultato viene rimosso, torna programmata.
            match.setStatus(MatchStatus.SCHEDULED);
        }

        footballMatchRepository.save(match);
        standingService.recalculateStandings(match.getCompetitionSeason().getId());

        return getMatchDetail(id);

    }

    public void delete(Long id) {
        if (!footballMatchRepository.existsById(id)) {
            throw new ResourceNotFoundException("Match non trovato con id: " +id);
        }

        footballMatchRepository.deleteById(id);
    }

}
