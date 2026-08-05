package com.footnest.footnest_backend.mapper;

import com.footnest.footnest_backend.dto.prediction.PredictionDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.Prediction;
import org.springframework.stereotype.Component;

@Component
public class PredictionMapper {

    public PredictionDTO toDTO(Prediction prediction) {

        FootballMatch match = prediction.getMatch();

        return new PredictionDTO(
                prediction.getId(),
                match.getId(),
                match.getHomeTeam().getName(),
                match.getAwayTeam().getName(),
                match.getHomeTeam().getLogoPath(),
                match.getAwayTeam().getLogoPath(),
                match.getDate(),
                match.getKickoffTime(),
                prediction.getPrediction(),
                prediction.getOdd()
        );
    }

}
