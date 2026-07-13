package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.config.AppConfig;
import com.footnest.footnest_backend.dto.competition.CompetitionDTO;
import com.footnest.footnest_backend.dto.competition.CompetitionDetailsDTO;
import com.footnest.footnest_backend.dto.competitionseason.CompetitionSeasonDTO;
import com.footnest.footnest_backend.entity.Competition;

import lombok.RequiredArgsConstructor;


@Component
@RequiredArgsConstructor
public class CompetitionMapper {

    private final AppConfig appConfig;


    public CompetitionDTO toDto(Competition competition) {

        return new CompetitionDTO(
                competition.getId(),
                competition.getName(),
                appConfig.getBaseUrl()
                        + "/uploads/"
                        + competition.getLogoPath(),
                competition.getType()
        );

    }

    public CompetitionDetailsDTO toDetailsDTO(Competition competition) {
        CompetitionDetailsDTO dto = new CompetitionDetailsDTO();
        dto.setId(competition.getId());
        dto.setName(competition.getName());
        dto.setLogoPath(
            appConfig.getBaseUrl()
            + "/uploads/"
            + competition.getLogoPath()
        );
        dto.setType(competition.getType());
        dto.setSeasons(
            competition.getSeasons()
            .stream()
            .map(season ->
                new CompetitionSeasonDTO(
                    season.getId(),
                    season.getSeason().getName()
                )
            )
            .toList()
        );
        return dto;
    }

}