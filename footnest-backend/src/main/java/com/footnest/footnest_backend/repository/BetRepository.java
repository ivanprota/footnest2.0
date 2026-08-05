package com.footnest.footnest_backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Bet;

public interface BetRepository extends JpaRepository<Bet, Long> {
    
    List<Bet> findByUserIdOrderByCreatedAtDesc(Long userId);

    List<Bet> findByUserId(Long userId);

}
