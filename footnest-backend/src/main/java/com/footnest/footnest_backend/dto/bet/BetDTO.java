package com.footnest.footnest_backend.dto.bet;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.List;

import com.footnest.footnest_backend.dto.betselection.BetSelectionDTO;

@Getter
@AllArgsConstructor
public class BetDTO {

    private Long id;

    private String name;

    private LocalDateTime createdAt;

    private String status;

    private List<BetSelectionDTO> selections;

}