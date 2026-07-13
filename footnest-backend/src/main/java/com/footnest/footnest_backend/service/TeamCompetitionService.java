package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.TeamCompetition;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.TeamCompetitionRepository;

@Service
public class TeamCompetitionService {
    
    private final TeamCompetitionRepository teamCompetitionRepository;

    public TeamCompetitionService(TeamCompetitionRepository teamCompetitionRepository) {
        this.teamCompetitionRepository = teamCompetitionRepository;
    }

        public List<TeamCompetition> findAll() {
        return teamCompetitionRepository.findAll();
    }

    public TeamCompetition findById(Long id) {
        return teamCompetitionRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Informazioni sulla competizione della squadra non trovate con id: " +id));
    }

    public TeamCompetition save(TeamCompetition teamCompetition) {
        return teamCompetitionRepository.save(teamCompetition);
    }

    public void delete(Long id) {
        if (!teamCompetitionRepository.existsById(id)) {
            throw new ResourceNotFoundException("Informazioni sulla competizione della squadra non trovate con id: " +id);
        }

        teamCompetitionRepository.deleteById(id);
    }

}
