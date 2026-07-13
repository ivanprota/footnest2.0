package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.Bet;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.BetRepository;

@Service
public class BetService {
    
    private final BetRepository betRepository;

    public BetService(BetRepository betRepository) {
        this.betRepository = betRepository;
    }

    public List<Bet> findAll() {
        return betRepository.findAll();
    }

    public Bet findById(Long id) {
        return betRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Schedina non trovata con id: " +id));
    }

    public Bet save(Bet bet) {
        return betRepository.save(bet);
    }

    public Bet update(Long id, Bet bet) {
        Bet existing = findById(id);

        existing.setName(bet.getName());
        existing.setStatus(bet.getStatus());

        return betRepository.save(existing);
    }

    public void delete(Long id) {
        if (!betRepository.existsById(id)) {
            throw new ResourceNotFoundException("Schedina non trovata con id: " +id);
        }

        betRepository.deleteById(id);
    }

}
