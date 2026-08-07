package com.footnest.footnest_backend.dto.betselection;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class BetSelectionDTO {

    private Long id;
    private Long predictionId;
    private Long matchId;
    private String homeTeam;
    private String awayTeam;
    private String homeLogo;
    private String awayLogo;
    private String competitionLogo;
    private String prediction;
    private Double odd;
    private Boolean settled;
    private Boolean won;

}