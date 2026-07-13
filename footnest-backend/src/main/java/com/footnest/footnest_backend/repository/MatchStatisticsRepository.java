package com.footnest.footnest_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.MatchStatistics;

public interface MatchStatisticsRepository extends JpaRepository<MatchStatistics, Long> {
    
}
