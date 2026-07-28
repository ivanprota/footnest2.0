package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.mapper.MatchStatisticsMapper;
import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsCreateDTO;
import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsDTO;
import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsUpdateDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.MatchStatistics;
import com.footnest.footnest_backend.entity.Team;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.FootballMatchRepository;
import com.footnest.footnest_backend.repository.MatchStatisticsRepository;
import com.footnest.footnest_backend.repository.TeamRepository;

@Service
public class MatchStatisticsService {
    
    private final MatchStatisticsMapper matchStatisticsMapper;
    private final MatchStatisticsRepository matchStatisticsRepository;
    private final FootballMatchRepository footballMatchRepository;
    private final TeamRepository teamRepository;

    public MatchStatisticsService(
        MatchStatisticsRepository matchStatisticsRepository, 
        MatchStatisticsMapper matchStatisticsMapper,
        FootballMatchRepository footballMatchRepository,
        TeamRepository teamRepository) 
    {
        this.matchStatisticsRepository = matchStatisticsRepository;
        this.matchStatisticsMapper = matchStatisticsMapper;
        this.footballMatchRepository = footballMatchRepository;
        this.teamRepository = teamRepository;
    }

    public List<MatchStatisticsDTO> findAll() {
        return matchStatisticsRepository.findAll()
                    .stream()
                    .map(matchStatisticsMapper::toDTO)
                    .toList();
    }

    public MatchStatisticsDTO findById(Long id) {
        MatchStatistics matchStatistics = matchStatisticsRepository.findById(id)
                                .orElseThrow(() -> 
                                    new ResourceNotFoundException("Statistiche del match non trovate con id: " +id));
        return matchStatisticsMapper.toDTO(matchStatistics);
    }

    public MatchStatistics save(MatchStatistics matchStatistics) {
        return matchStatisticsRepository.save(matchStatistics);
    }

    public MatchStatisticsDTO create(MatchStatisticsCreateDTO dto) {

        FootballMatch match = footballMatchRepository.findById(dto.getMatchId())
                .orElseThrow(() ->
                        new ResourceNotFoundException("Partita non trovata"));

        Team team = teamRepository.findById(dto.getTeamId())
                .orElseThrow(() ->
                        new ResourceNotFoundException("Squadra non trovata"));

        MatchStatistics statistics = matchStatisticsMapper.fromCreateDTO(dto);

        statistics.setMatch(match);
        statistics.setTeam(team);

        return matchStatisticsMapper.toDTO(
                matchStatisticsRepository.save(statistics)
        );
    }

    public MatchStatisticsDTO update(Long id, MatchStatisticsUpdateDTO dto) {
        MatchStatistics existing =
                matchStatisticsRepository.findById(id)
                .orElseThrow(
                    () -> new ResourceNotFoundException(
                        "Statistiche non trovate"
                    )
                );


        existing.setXg(dto.getXg());
        existing.setPossession(dto.getPossession());
        existing.setTotalShots(dto.getTotalShots());
        existing.setShotsOnTarget(dto.getShotsOnTarget());
        existing.setBigChances(dto.getBigChances());
        existing.setCorners(dto.getCorners());
        existing.setYellowCards(dto.getYellowCards());
        existing.setRedCards(dto.getRedCards());
        existing.setFouls(dto.getFouls());


        return matchStatisticsMapper.toDTO(
            matchStatisticsRepository.save(existing)
        );
    }

    public void delete(Long id) {
        if (!matchStatisticsRepository.existsById(id)) {
            throw new ResourceNotFoundException("Statistiche del match non trovate con id: " +id);
        }

        matchStatisticsRepository.deleteById(id);
    }

}
