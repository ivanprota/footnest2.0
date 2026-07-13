package com.footnest.footnest_backend.dto.standing;

import com.footnest.footnest_backend.dto.team.TeamDTO;

import lombok.*;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StandingDTO {

    private Integer position;
    private TeamDTO team;
    private Integer played;
    private Integer wins;
    private Integer draws;
    private Integer losses;
    private Integer goalsFor;
    private Integer goalsAgainst;
    private Integer points;
    private Double totalXg;

}
