package com.footnest.footnest_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Bet;

public interface BetRepository extends JpaRepository<Bet, Long> {
    
}
