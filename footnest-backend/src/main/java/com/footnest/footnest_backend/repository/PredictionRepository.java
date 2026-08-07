package com.footnest.footnest_backend.repository;

import com.footnest.footnest_backend.entity.Prediction;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PredictionRepository extends JpaRepository<Prediction, Long> {

    List<Prediction> findByUserId(Long userId);

    Page<Prediction> findByUserIdOrderByCreatedAtDesc(
        Long userId,
        Pageable pageable
    );

    List<Prediction> findByUserIdAndMatchId(Long userId, Long matchId);
}