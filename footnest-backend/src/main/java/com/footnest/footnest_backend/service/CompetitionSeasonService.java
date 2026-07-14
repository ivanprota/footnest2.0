package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.competitionseason.CompetitionSeasonDTO;
import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.mapper.CompetitionSeasonMapper;
import com.footnest.footnest_backend.repository.CompetitionSeasonRepository;

@Service
public class CompetitionSeasonService {

    private final CompetitionSeasonRepository competitionSeasonRepository;
    private final CompetitionSeasonMapper competitionSeasonMapper;

    public CompetitionSeasonService(CompetitionSeasonRepository competitionSeasonRepository, 
        CompetitionSeasonMapper competitionSeasonMapper) {
        this.competitionSeasonRepository = competitionSeasonRepository;
        this.competitionSeasonMapper = competitionSeasonMapper;
    }

    public List<CompetitionSeasonDTO> findAll() {
        return competitionSeasonRepository.findAll()
                    .stream()
                    .map(competitionSeasonMapper::toDTO)
                    .toList();
    }

    public CompetitionSeason findById(Long id) {
        return competitionSeasonRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Competizione stagionale non trovata con id: " +id));
    }

    public CompetitionSeason save(CompetitionSeason competitionSeason) {
        return competitionSeasonRepository.save(competitionSeason);
    }

    public void delete(Long id) {
        if (!competitionSeasonRepository.existsById(id)) {
            throw new ResourceNotFoundException("Competizione stagionale non trovata con id: " +id);
        }

        competitionSeasonRepository.deleteById(id);
    }

}
