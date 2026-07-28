package com.footnest.footnest_backend.dto.matchstatistics;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MatchStatisticsDTO {

    private Long id;

    private Long teamId;

    private String teamName;

    private String teamLogo;

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
