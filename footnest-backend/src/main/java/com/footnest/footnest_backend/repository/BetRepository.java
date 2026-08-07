package com.footnest.footnest_backend.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Bet;

public interface BetRepository extends JpaRepository<Bet, Long> {
    
    Page<Bet> findByUserIdOrderByCreatedAtDesc(
        Long userId,
        Pageable pageable
    );

    List<Bet> findByUserId(Long userId);

}
