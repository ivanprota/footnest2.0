package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "matches")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FootballMatch {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "competition_season_id", nullable = false)
    private CompetitionSeason competitionSeason;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "home_team_id", nullable = false)
    private Team homeTeam;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "away_team_id", nullable = false)
    private Team awayTeam;


    @Column(nullable = false)
    private LocalDate date;


    private Integer homeGoals;

    private Integer awayGoals;

    @OneToMany(mappedBy = "match")
    private List<MatchStatistics> statistics = new ArrayList<>();

    @OneToMany(mappedBy = "match")
    private List<BetSelection> selections = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "season_id", nullable = false)
    private Season season;


    @Enumerated(EnumType.STRING)
    private MatchStatus status;


    public enum MatchStatus {
        SCHEDULED,
        PLAYED,
        CANCELLED
    }
}