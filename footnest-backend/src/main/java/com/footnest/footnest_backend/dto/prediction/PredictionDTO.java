package com.footnest.footnest_backend.dto.prediction;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PredictionDTO {

    private Long id;

    private Long matchId;

    private String homeTeam;

    private String awayTeam;

    private String homeLogo;

    private String awayLogo;

    private LocalDate date;

    private LocalTime kickoffTime;

    private String prediction;

    private Double odd;

}