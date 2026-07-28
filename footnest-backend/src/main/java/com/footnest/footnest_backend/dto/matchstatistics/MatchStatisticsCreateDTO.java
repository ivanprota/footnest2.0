package com.footnest.footnest_backend.dto.matchstatistics;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MatchStatisticsCreateDTO {

    private Long matchId;

    private Long teamId;

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
