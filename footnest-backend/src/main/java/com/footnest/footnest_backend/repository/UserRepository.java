package com.footnest.footnest_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.footnest.footnest_backend.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
    
}
