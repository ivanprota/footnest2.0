package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.team.TeamDTO;
import com.footnest.footnest_backend.entity.Team;

import lombok.RequiredArgsConstructor;

import com.footnest.footnest_backend.config.AppConfig;

@Component
@RequiredArgsConstructor
public class TeamMapper {

    private final AppConfig appConfig;

    public TeamDTO toDTO(Team team) {
        return new TeamDTO(
                team.getId(),
                team.getName(),
                appConfig.getBaseUrl() + "/uploads/" + team.getLogoPath()
            );
    }

}