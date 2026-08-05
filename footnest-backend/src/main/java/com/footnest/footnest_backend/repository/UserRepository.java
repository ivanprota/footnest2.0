package com.footnest.footnest_backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByUsername(String username);

    boolean existsByUsername(String username);

}
