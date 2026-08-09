package com.footnest.footnest_backend.dto.team;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TeamMatchStatisticsDTO {

    private Long matchId;
    private Long teamId;

    private Long homeTeamId;
    private Long awayTeamId;

    private LocalDate date;

    private String homeTeam;
    private String awayTeam;

    private String homeLogo;
    private String awayLogo;

    private Integer homeGoals;
    private Integer awayGoals;

    private MatchTeamStatisticsDTO homeStatistics;
    private MatchTeamStatisticsDTO awayStatistics;
}