package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "predictions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Prediction {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "match_id", nullable = false)
    private FootballMatch match;


    @Column(nullable = false)
    private String prediction;

    @OneToMany(mappedBy = "prediction")
    private List<BetSelection> selections = new ArrayList<>();

    @Column(nullable = false)
    private Double odd;


    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private Boolean settled = false;

    private Boolean won;

}