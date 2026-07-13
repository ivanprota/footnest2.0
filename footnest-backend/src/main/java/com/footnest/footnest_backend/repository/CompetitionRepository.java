package com.footnest.footnest_backend.repository;
 
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Competition;

public interface CompetitionRepository extends JpaRepository<Competition, Long> {

    Optional<Competition> findByName(String name);

}
