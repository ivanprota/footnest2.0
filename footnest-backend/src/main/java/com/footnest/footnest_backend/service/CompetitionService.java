package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.mapper.CompetitionMapper;
import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.competition.CompetitionDTO;
import com.footnest.footnest_backend.dto.competition.CompetitionDetailsDTO;
import com.footnest.footnest_backend.entity.Competition;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.CompetitionRepository;


@Service
public class CompetitionService {
    
    private final CompetitionMapper competitionMapper;
    private final CompetitionRepository competitionRepository;

    public CompetitionService(CompetitionRepository competitionRepository, CompetitionMapper competitionMapper) {
        this.competitionRepository = competitionRepository;
        this.competitionMapper = competitionMapper;
    }

    public List<CompetitionDTO> findAll() {
        return competitionRepository.findAll()
                    .stream()
                    .map(competitionMapper::toDto)
                    .toList();
    }

    public CompetitionDTO findById(Long id) {
        Competition competition = competitionRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Competizione non trovata con id: " +id));

        return competitionMapper.toDto(competition);
    }

    public CompetitionDetailsDTO findDetailsById(Long id) {
        Competition competition =
                competitionRepository.findById(id)
                .orElseThrow(() ->
                    new ResourceNotFoundException(
                        "Competizione non trovata"
                    )
                );

        return competitionMapper.toDetailsDTO(competition);
    }

    public Competition save(Competition competition) {
        return competitionRepository.save(competition);
    }

    // public Competition update(Long id, Competition competition) {
    //     Competition existing = findById(id);

    //     existing.setName(competition.getName());
    //     existing.setLogoPath(competition.getLogoPath());
    //     existing.setType(competition.getType());

    //     return competitionRepository.save(existing);
    // }

    public void delete(Long id) {
        if (!competitionRepository.existsById(id)) {
            throw new ResourceNotFoundException("Competizione non trovata con id: " +id);
        }

        competitionRepository.deleteById(id);
    }

}
