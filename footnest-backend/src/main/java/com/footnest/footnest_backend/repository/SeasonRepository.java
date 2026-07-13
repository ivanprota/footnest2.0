package com.footnest.footnest_backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Season;

public interface SeasonRepository extends JpaRepository<Season, Long> {
    
    Optional<Season> findByName(String name);

}
