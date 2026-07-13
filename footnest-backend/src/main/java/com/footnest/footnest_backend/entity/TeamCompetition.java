package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
    name = "team_competitions",
    uniqueConstraints = {
        @UniqueConstraint(
            columnNames = {
                "team_id",
                "competition_season_id"
            }
        )
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TeamCompetition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_id", nullable = false)
    private Team team;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "competition_season_id", nullable = false)
    private CompetitionSeason competitionSeason;

    @ManyToOne
    @JoinColumn(name = "season_id")
    private Season season;
}