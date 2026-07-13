package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.MatchStatistics;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.MatchStatisticsRepository;

@Service
public class MatchStatisticsService {
    
    private final MatchStatisticsRepository matchStatisticsRepository;

    public MatchStatisticsService(MatchStatisticsRepository matchStatisticsRepository) {
        this.matchStatisticsRepository = matchStatisticsRepository;
    }

    public List<MatchStatistics> findAll() {
        return matchStatisticsRepository.findAll();
    }

    public MatchStatistics findById(Long id) {
        return matchStatisticsRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Statistiche del match non trovate con id: " +id));
    }

    public MatchStatistics save(MatchStatistics matchStatistics) {
        return matchStatisticsRepository.save(matchStatistics);
    }

    public MatchStatistics update(Long id, MatchStatistics matchStatistics) {
        MatchStatistics existing = findById(id);

        existing.setXg(matchStatistics.getXg());
        existing.setPossession(matchStatistics.getPossession());
        existing.setTotalShots(matchStatistics.getTotalShots());
        existing.setShotsOnTarget(matchStatistics.getShotsOnTarget());
        existing.setBigChances(matchStatistics.getBigChances());
        existing.setCorners(matchStatistics.getCorners());
        existing.setYellowCards(matchStatistics.getYellowCards());
        existing.setRedCards(matchStatistics.getRedCards());
        existing.setFouls(matchStatistics.getFouls());

        return matchStatisticsRepository.save(matchStatistics);
    }

    public void delete(Long id) {
        if (!matchStatisticsRepository.existsById(id)) {
            throw new ResourceNotFoundException("Statistiche del match non trovate con id: " +id);
        }

        matchStatisticsRepository.deleteById(id);
    }

}
