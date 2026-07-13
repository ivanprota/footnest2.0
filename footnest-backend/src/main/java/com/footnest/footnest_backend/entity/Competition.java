package com.footnest.footnest_backend.entity;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "competitions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Competition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String logoPath;


    @Enumerated(EnumType.STRING)
    private CompetitionType type;


    @OneToMany(mappedBy = "competition")
    private List<CompetitionSeason> seasons = new ArrayList<>();


    public enum CompetitionType {
        LEAGUE,
        CUP
    }
}