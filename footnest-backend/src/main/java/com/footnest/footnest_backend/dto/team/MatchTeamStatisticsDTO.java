package com.footnest.footnest_backend.dto.team;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MatchTeamStatisticsDTO {

    private Double xg;
    private Double possession;
    private Integer totalShots;
    private Integer shotsOnTarget;
    private Integer bigChances;
    private Integer corners;
    private Integer yellowCards;
    private Integer redCards;
    private Integer fouls;
}