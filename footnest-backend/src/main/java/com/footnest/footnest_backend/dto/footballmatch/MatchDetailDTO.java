package com.footnest.footnest_backend.dto.footballmatch;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsDTO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MatchDetailDTO {

    private Long id;
    private Long homeTeamId;
    private Long awayTeamId;
    private String homeTeam;
    private String awayTeam;
    private String homeLogo;
    private String awayLogo;
    private LocalDate date;
    private LocalTime kickoffTime;
    private Integer homeGoals;
    private Integer awayGoals;
    private Integer matchday;
    private String status;
    private String competition;
    private String season;
    private List<MatchStatisticsDTO> statistics;
}
