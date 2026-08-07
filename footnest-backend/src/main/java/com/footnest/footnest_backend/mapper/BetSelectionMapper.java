package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.betselection.BetSelectionDTO;
import com.footnest.footnest_backend.entity.BetSelection;

@Component
public class BetSelectionMapper {

public BetSelectionDTO toDTO(BetSelection selection) {


    var prediction = selection.getPrediction();

    var match = prediction.getMatch();


    return new BetSelectionDTO(
        selection.getId(),
        prediction.getId(),
        match.getId(),
        match.getHomeTeam().getName(),
        match.getAwayTeam().getName(),
        match.getHomeTeam().getLogoPath(),
        match.getAwayTeam().getLogoPath(),
        match.getCompetitionSeason().getCompetition().getLogoPath(),
        prediction.getPrediction(),
        prediction.getOdd(),
        prediction.getSettled(),
        prediction.getWon()

    );

}

}