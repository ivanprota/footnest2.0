package com.footnest.footnest_backend.entity;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;

import lombok.*;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "teams")
public class Team {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String logoPath;

    @OneToMany(mappedBy = "team")
    private List<TeamCompetition> participations = new ArrayList<>();

    @OneToMany(mappedBy = "homeTeam")
    private List<FootballMatch> homeMatches = new ArrayList<>();


    @OneToMany(mappedBy = "awayTeam")
    private List<FootballMatch> awayMatches = new ArrayList<>();

    @OneToMany(mappedBy = "team")
    private List<MatchStatistics> statistics = new ArrayList<>();

    @OneToMany(mappedBy = "team")
    private List<Standing> standings = new ArrayList<>();
}