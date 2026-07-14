package com.footnest.footnest_backend.dto.team;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TeamCreateDTO {

    private String name;
    private String logoPath;
    private Long competitionSeasonId;

}
