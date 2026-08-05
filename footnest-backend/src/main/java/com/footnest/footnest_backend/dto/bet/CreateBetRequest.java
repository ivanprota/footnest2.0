package com.footnest.footnest_backend.dto.bet;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

import com.footnest.footnest_backend.dto.betselection.CreateBetSelectionRequest;

@Getter
@Setter
public class CreateBetRequest {

    private String name;

    private List<CreateBetSelectionRequest> selections;

}
