package com.footnest.footnest_backend.dto.competition;

import java.util.List;

import com.footnest.footnest_backend.dto.competitionseason.CompetitionSeasonDTO;
import com.footnest.footnest_backend.entity.Competition.CompetitionType;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompetitionDetailsDTO {

    private Long id;
    private String name;
    private String logoPath;
    private CompetitionType type;
    private List<CompetitionSeasonDTO> seasons;

}