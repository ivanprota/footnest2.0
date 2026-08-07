package com.footnest.footnest_backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.BetSelection;

public interface BetSelectionRepository extends JpaRepository<BetSelection, Long> {
 
    List<BetSelection> findByPredictionId(Long predictionId);
    
}
