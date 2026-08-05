package com.footnest.footnest_backend.dto.prediction;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreatePredictionRequest {

    private Long matchId;

    private String prediction;

    private Double odd;

}