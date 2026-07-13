package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.FootballMatchRepository;

@Service
public class FootballMatchService {
    
    private final FootballMatchRepository footballMatchRepository;

    public FootballMatchService(FootballMatchRepository footballMatchRepository) {
        this.footballMatchRepository = footballMatchRepository;
    }

    public List<FootballMatch> findAll() {
        return footballMatchRepository.findAll();
    }

    public FootballMatch findById(Long id) {
        return footballMatchRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Match non trovato con id: " +id));
    }

    public FootballMatch save(FootballMatch footballMatch) {
        return footballMatchRepository.save(footballMatch);
    }

    public FootballMatch update(Long id, FootballMatch footballMatch) {
        FootballMatch existing = findById(id);

        existing.setHomeGoals(footballMatch.getHomeGoals());
        existing.setAwayGoals(footballMatch.getAwayGoals());

        return footballMatchRepository.save(existing);
    }

    public void delete(Long id) {
        if (!footballMatchRepository.existsById(id)) {
            throw new ResourceNotFoundException("Match non trovato con id: " +id);
        }

        footballMatchRepository.deleteById(id);
    }

}
