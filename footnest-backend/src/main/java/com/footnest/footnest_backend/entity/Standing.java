package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
    name = "standings",
    uniqueConstraints = {
        @UniqueConstraint(
            columnNames = {
                "competition_season_id",
                "team_id"
            }
        )
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Standing {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "competition_season_id", nullable = false)
    private CompetitionSeason competitionSeason;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_id", nullable = false)
    private Team team;


    private Integer played = 0;

    private Integer wins = 0;

    private Integer draws = 0;

    private Integer losses = 0;


    private Integer goalsFor = 0;

    private Integer goalsAgainst = 0;


    private Integer points = 0;


    private Double totalXg = 0.0;
}