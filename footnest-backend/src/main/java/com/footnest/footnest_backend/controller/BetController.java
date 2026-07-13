package com.footnest.footnest_backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.footnest.footnest_backend.entity.Bet;
import com.footnest.footnest_backend.service.BetService;

@RestController
@RequestMapping("/bets")
@CrossOrigin
public class BetController {
    
    private final BetService betService;

    public BetController(BetService betService) {
        this.betService = betService;
    }

    @GetMapping
    public List<Bet> getAll() {
        return betService.findAll();
    }

    @GetMapping("/{id}")
    public Bet getById(@PathVariable Long id) {
        return betService.findById(id);
    }

    @PostMapping
    public Bet create(@RequestBody Bet bet) {
        return betService.save(bet);
    }

    @PutMapping("/{id}")
    public Bet update(@PathVariable Long id, @RequestBody Bet bet) {
        return betService.update(id, bet);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        betService.delete(id);
    }

}
