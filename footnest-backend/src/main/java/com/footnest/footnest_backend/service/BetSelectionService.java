package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.BetSelection;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.BetSelectionRepository;

@Service
public class BetSelectionService {
    
    private final BetSelectionRepository betSelectionRepository;

    public BetSelectionService(BetSelectionRepository betSelectionRepository) {
        this.betSelectionRepository = betSelectionRepository;
    }

    public List<BetSelection> findAll() {
        return betSelectionRepository.findAll();
    }

    public BetSelection findById(Long id) {
        return betSelectionRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Pronostisco non trovato con id: " +id));
    }

    public BetSelection save(BetSelection betSelection) {
        return betSelectionRepository.save(betSelection);
    }

    public BetSelection update(Long id, BetSelection betSelection) {
        BetSelection exsisting = findById(id);

        exsisting.setSettled(betSelection.getSettled());
        exsisting.setWon(betSelection.getWon());

        return betSelectionRepository.save(exsisting);
    }

    public void delete(Long id) {
        if (!betSelectionRepository.existsById(id)) {
            throw new ResourceNotFoundException("Pronostisco non trovato con id: " +id);
        }

        betSelectionRepository.deleteById(id);
    }

}
