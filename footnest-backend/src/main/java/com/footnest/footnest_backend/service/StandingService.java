package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.mapper.StandingMapper;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.standing.StandingDTO;
import com.footnest.footnest_backend.entity.Standing;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.StandingRepository;

@Service
public class StandingService {
    
    private final StandingMapper standingMapper;
    private final StandingRepository standingRepository;

    public StandingService(StandingRepository standingRepository, StandingMapper standingMapper) {
        this.standingRepository = standingRepository;
        this.standingMapper = standingMapper;
    }

    public List<Standing> findAll() {
        return standingRepository.findAll();
    }

    public Standing findById(Long id) {
        return standingRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Dati squadra per classifica non trovati con id: " +id));
    }

    public List<StandingDTO> getByCompetitionSeason(Long competitionSeasonId) {
        List<Standing> standings = standingRepository.findByCompetitionSeasonIdOrderByPointsDesc(competitionSeasonId);
        int position = 1;
        List<StandingDTO> result = new ArrayList<>();

        for (Standing standing : standings) {
            result.add(standingMapper.toDTO(standing, position));
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

}
