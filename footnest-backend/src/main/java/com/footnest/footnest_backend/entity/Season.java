package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import lombok.*;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "seasons")
public class Season {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    private LocalDate startDate;

    private LocalDate endDate;

    @OneToMany(mappedBy = "season")
    private List<TeamCompetition> teamCompetitions = new ArrayList<>();

    @OneToMany(mappedBy = "season")
    private List<FootballMatch> matches = new ArrayList<>();

    @OneToMany(mappedBy = "season")
    private List<CompetitionSeason> competitionSeason = new ArrayList<>();

}