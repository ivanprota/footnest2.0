package com.footnest.footnest_backend.dto.footballmatch;

import lombok.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MatchSummaryDTO {

    private Long id;
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

}
