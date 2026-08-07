package com.footnest.footnest_backend.controller;

import com.footnest.footnest_backend.dto.bet.BetDTO;
import com.footnest.footnest_backend.dto.bet.CreateBetRequest;
import com.footnest.footnest_backend.dto.common.PageResponse;
import com.footnest.footnest_backend.service.BetService;

import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

@RestController
@RequestMapping("/bets")
@CrossOrigin
public class BetController {

    private final BetService betService;

    public BetController(BetService betService) {
        this.betService = betService;
    }

    @GetMapping("/my")
    public PageResponse<BetDTO> getMyBets(
            Authentication authentication,
            @RequestParam(defaultValue="0") int page,
            @RequestParam(defaultValue="10") int size
    )
    {
        return betService.findPage(
                authentication.getName(),
                page,
                size
        );
    }

    @PostMapping
    public BetDTO create(Authentication authentication, @RequestBody CreateBetRequest request){
        return betService.create(authentication.getName(), request);
    }
}