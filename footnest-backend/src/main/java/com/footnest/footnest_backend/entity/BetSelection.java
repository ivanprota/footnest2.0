package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "bet_selections")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BetSelection {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bet_id", nullable = false)
    private Bet bet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "prediction_id", nullable = false)
    private Prediction prediction;

}