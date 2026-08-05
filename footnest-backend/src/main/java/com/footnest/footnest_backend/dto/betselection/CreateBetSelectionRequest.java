package com.footnest.footnest_backend.dto.betselection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateBetSelectionRequest {

    private Long matchId;

    private String prediction;

    private Double odd;

}
