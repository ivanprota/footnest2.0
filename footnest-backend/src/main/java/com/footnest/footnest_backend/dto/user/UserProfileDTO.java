package com.footnest.footnest_backend.dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class UserProfileDTO {

    private String username;

    private LocalDateTime createdAt;

    private boolean admin;


    private int totalBets;

    private int wonBets;

    private int lostBets;

    private int openBets;


    private int totalPredictions;

    private int wonPredictions;

    private int lostPredictions;

    private int openPredictions;


}