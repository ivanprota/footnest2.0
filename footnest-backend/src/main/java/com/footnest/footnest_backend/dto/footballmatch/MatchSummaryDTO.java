package com.footnest.footnest_backend.dto.footballmatch;

import lombok.*;
import java.time.LocalDate;

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
    private Integer homeGoals;
    private Integer awayGoals;
    private String status;

}
