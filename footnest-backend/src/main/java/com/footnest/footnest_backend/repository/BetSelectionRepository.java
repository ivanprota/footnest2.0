package com.footnest.footnest_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.BetSelection;

public interface BetSelectionRepository extends JpaRepository<BetSelection, Long> {
    
}
