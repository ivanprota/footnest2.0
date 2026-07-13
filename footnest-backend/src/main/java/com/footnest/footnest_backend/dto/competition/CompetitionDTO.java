package com.footnest.footnest_backend.dto.competition;

import com.footnest.footnest_backend.entity.Competition.CompetitionType;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompetitionDTO {

    private Long id;

    private String name;

    private String logoPath;

    private CompetitionType type;

}