package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsCreateDTO;
import com.footnest.footnest_backend.dto.matchstatistics.MatchStatisticsDTO;
import com.footnest.footnest_backend.entity.MatchStatistics;

@Component
public class MatchStatisticsMapper {


    public MatchStatisticsDTO toDTO(MatchStatistics statistics) {
        return new MatchStatisticsDTO(
            statistics.getId(),
            statistics.getTeam().getId(),
            statistics.getTeam().getName(),
            statistics.getTeam().getLogoPath(),
            statistics.getXg(),
            statistics.getPossession(),
            statistics.getTotalShots(),
            statistics.getShotsOnTarget(),
            statistics.getBigChances(),
            statistics.getCorners(),
            statistics.getYellowCards(),
            statistics.getRedCards(),
            statistics.getFouls()
        );
    }

    public MatchStatistics fromCreateDTO(MatchStatisticsCreateDTO dto) {

        MatchStatistics statistics = new MatchStatistics();

        statistics.setXg(dto.getXg());
        statistics.setPossession(dto.getPossession());
        statistics.setTotalShots(dto.getTotalShots());
        statistics.setShotsOnTarget(dto.getShotsOnTarget());
        statistics.setBigChances(dto.getBigChances());
        statistics.setCorners(dto.getCorners());
        statistics.setYellowCards(dto.getYellowCards());
        statistics.setRedCards(dto.getRedCards());
        statistics.setFouls(dto.getFouls());

        return statistics;
    }

}
