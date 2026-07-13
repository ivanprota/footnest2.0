package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
    name = "competition_seasons",
    uniqueConstraints = {
        @UniqueConstraint(
            columnNames = {
                "competition_id",
                "season_id"
            }
        )
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompetitionSeason {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "competition_id", nullable = false)
    private Competition competition;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "season_id", nullable = false)
    private Season season;


    @OneToMany(mappedBy = "competitionSeason")
    private List<TeamCompetition> teams = new ArrayList<>();

    @OneToMany(mappedBy = "competitionSeason")
    private List<FootballMatch> matches = new ArrayList<>();

    @OneToMany(mappedBy = "competitionSeason")
    private List<Standing> standings = new ArrayList<>();
}