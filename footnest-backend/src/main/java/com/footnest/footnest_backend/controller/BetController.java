package com.footnest.footnest_backend.controller;

import com.footnest.footnest_backend.dto.bet.BetDTO;
import com.footnest.footnest_backend.dto.bet.CreateBetRequest;
import com.footnest.footnest_backend.service.BetService;

import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

import java.util.List;


@RestController
@RequestMapping("/bets")
@CrossOrigin
public class BetController {

    private final BetService betService;

    public BetController(BetService betService) {
        this.betService = betService;
    }

    @GetMapping
    public List<BetDTO> getMyBets(Authentication authentication){
        return betService.findAll(authentication.getName());
    }

    @PostMapping
    public BetDTO create(Authentication authentication, @RequestBody CreateBetRequest request){
        return betService.create(authentication.getName(), request);
    }
}