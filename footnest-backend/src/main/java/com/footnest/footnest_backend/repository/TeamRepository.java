package com.footnest.footnest_backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.Team;

public interface TeamRepository extends JpaRepository<Team, Long> {
    
    Optional<Team> findByName(String name);

    Optional<Team> findByNameIgnoreCase(String name);

}
