package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.betselection.BetSelectionDTO;
import com.footnest.footnest_backend.entity.BetSelection;

@Component
public class BetSelectionMapper {


    public BetSelectionDTO toDTO(BetSelection selection) {

        var match = selection.getMatch();


        return new BetSelectionDTO(

            selection.getId(),

            match.getId(),

            match.getHomeTeam().getName(),

            match.getAwayTeam().getName(),

            match.getHomeTeam().getLogoPath(),

            match.getAwayTeam().getLogoPath(),

            selection.getPrediction(),

            selection.getOdd(),

            selection.getSettled(),

            selection.getWon()

        );

    }

}