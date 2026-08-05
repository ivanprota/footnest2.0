package com.footnest.footnest_backend.mapper;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.dto.bet.BetDTO;
import com.footnest.footnest_backend.entity.Bet;

@Component
public class BetMapper {


    private final BetSelectionMapper betSelectionMapper;


    public BetMapper(
        BetSelectionMapper betSelectionMapper
    ){
        this.betSelectionMapper = betSelectionMapper;
    }



    public BetDTO toDTO(Bet bet){


        return new BetDTO(

            bet.getId(),

            bet.getName(),

            bet.getCreatedAt(),

            bet.getStatus().name(),


            bet.getSelections()
                .stream()
                .map(betSelectionMapper::toDTO)
                .toList()

        );

    }

}