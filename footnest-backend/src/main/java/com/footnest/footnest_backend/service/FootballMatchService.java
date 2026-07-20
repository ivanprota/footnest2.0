package com.footnest.footnest_backend.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.footballmatch.CompetitionMatchesDTO;
import com.footnest.footnest_backend.dto.footballmatch.MatchSummaryDTO;
import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.mapper.CompetitionSeasonMapper;
import com.footnest.footnest_backend.mapper.FootballMatchMapper;
import com.footnest.footnest_backend.repository.FootballMatchRepository;

@Service
public class FootballMatchService {
    
    private final FootballMatchRepository footballMatchRepository;
    private final FootballMatchMapper footballMatchMapper;
    private final CompetitionSeasonMapper competitionSeasonMapper;

    public FootballMatchService(
        FootballMatchRepository footballMatchRepository, 
        FootballMatchMapper footballMatchMapper,
        CompetitionSeasonMapper competitionSeasonMapper) {
        this.footballMatchRepository = footballMatchRepository;
        this.footballMatchMapper = footballMatchMapper;
        this.competitionSeasonMapper = competitionSeasonMapper;
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

    public void delete(Long id) {
        if (!footballMatchRepository.existsById(id)) {
            throw new ResourceNotFoundException("Match non trovato con id: " +id);
        }

        footballMatchRepository.deleteById(id);
    }

}
