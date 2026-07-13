package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
    name = "match_statistics",
    uniqueConstraints = {
        @UniqueConstraint(
            columnNames = {"match_id", "team_id"}
        )
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MatchStatistics {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "match_id", nullable = false)
    private FootballMatch match;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_id", nullable = false)
    private Team team;


    private Double xg;

    private Double possession;

    private Integer totalShots;

    private Integer shotsOnTarget;

    private Integer bigChances;

    private Integer corners;

    private Integer yellowCards;

    private Integer redCards;

    private Integer fouls;
}