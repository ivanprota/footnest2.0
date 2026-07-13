package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.Season;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.SeasonRepository;

@Service
public class SeasonService {
    
    private final SeasonRepository seasonRepository;

    public SeasonService(SeasonRepository seasonRepository) {
        this.seasonRepository = seasonRepository;
    }

    public List<Season> findAll() {
        return seasonRepository.findAll();
    }

    public Season findById(Long id) {
        return seasonRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Stagione non trovata con id: " +id));
    }

    public Season save(Season season) {
        return seasonRepository.save(season);
    }

    public void delete(Long id) {
        if (!seasonRepository.existsById(id)) {
            throw new ResourceNotFoundException("Stagione non trovata con id: " +id);
        }

        seasonRepository.deleteById(id);
    }

}
