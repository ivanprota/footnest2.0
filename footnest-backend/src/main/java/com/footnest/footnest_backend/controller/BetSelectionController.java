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

import com.footnest.footnest_backend.entity.BetSelection;
import com.footnest.footnest_backend.service.BetSelectionService;

@RestController
@RequestMapping("/bet-selections")
@CrossOrigin
public class BetSelectionController {
    
    private BetSelectionService betSelectionService;

    public BetSelectionController(BetSelectionService betSelectionService) {
        this.betSelectionService = betSelectionService;
    }

    @GetMapping
    public List<BetSelection> getAll() {
        return betSelectionService.findAll();
    }

    @GetMapping("/{id}")
    public BetSelection getById(@PathVariable Long id) {
        return betSelectionService.findById(id);
    }

    @PostMapping
    public BetSelection create(@RequestBody BetSelection betSelection) {
        return betSelectionService.save(betSelection);
    }

    @PutMapping("/{id}")
    public BetSelection update(@PathVariable Long id, @RequestBody BetSelection betSelection) {
        return betSelectionService.update(id, betSelection);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        betSelectionService.delete(id);
    }

}
