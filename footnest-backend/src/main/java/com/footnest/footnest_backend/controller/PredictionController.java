package com.footnest.footnest_backend.controller;

import com.footnest.footnest_backend.dto.common.PageResponse;
import com.footnest.footnest_backend.dto.prediction.CreatePredictionRequest;
import com.footnest.footnest_backend.dto.prediction.PredictionDTO;
import com.footnest.footnest_backend.service.PredictionService;

import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

import java.util.List;

@RestController
@RequestMapping("/predictions")
@CrossOrigin
public class PredictionController {

    private final PredictionService predictionService;

    public PredictionController(PredictionService predictionService) {
        this.predictionService = predictionService;
    }

    @GetMapping
    public List<PredictionDTO> getMyPredictions(Authentication authentication) {
        String username = authentication.getName();
        return predictionService.findAllByUsername(username);
    }

    @GetMapping("/my")
    public PageResponse<PredictionDTO> getMyPredictionsPage(
            Authentication authentication,
            @RequestParam(defaultValue="0") int page,
            @RequestParam(defaultValue="10") int size
    )
    {
        return predictionService.findPage(
                authentication.getName(),
                page,
                size
        );
    }

    @GetMapping("/match/{matchId}")
    public List<PredictionDTO> getByMatch(@PathVariable Long matchId, Authentication authentication) {
        return predictionService.findByMatch(authentication.getName(), matchId);
    }

    @PostMapping
    public PredictionDTO createPrediction(Authentication authentication, @RequestBody CreatePredictionRequest request) {
        return predictionService.savePrediction(authentication.getName(), request);
    }

    @DeleteMapping("/{id}")
    public void deletePrediction(@PathVariable Long id, Authentication authentication) {
        predictionService.deletePrediction(id, authentication.getName());
    }

}