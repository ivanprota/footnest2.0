package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.user.UserProfileDTO;
import com.footnest.footnest_backend.entity.Bet;
import com.footnest.footnest_backend.entity.Prediction;
import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.repository.BetRepository;
import com.footnest.footnest_backend.repository.PredictionRepository;
import com.footnest.footnest_backend.repository.UserRepository;

@Service
public class UserProfileService {

    private final UserRepository userRepository;

    private final BetRepository betRepository;

    private final PredictionRepository predictionRepository;


    public UserProfileService(
            UserRepository userRepository,
            BetRepository betRepository,
            PredictionRepository predictionRepository
    )
    {
        this.userRepository = userRepository;
        this.betRepository = betRepository;
        this.predictionRepository = predictionRepository;
    }

    public UserProfileDTO getProfile(String username) {
        User user = userRepository.findByUsername(username).orElseThrow();
        return buildProfile(user);
    }

    public UserProfileDTO getProfileById(Long id) {
        User user = userRepository.findById(id)
                        .orElseThrow(() -> new RuntimeException("Utente non trovato"));
        
        return buildProfile(user);
    }

    private UserProfileDTO buildProfile(User user) {

        List<Bet> bets = betRepository.findByUserId(user.getId());
        List<Prediction> predictions = predictionRepository.findByUserId(user.getId());

        int wonBets = (int) bets.stream().filter(b -> b.getStatus() == Bet.BetStatus.WON).count();
        int lostBets = (int) bets.stream().filter(b -> b.getStatus() == Bet.BetStatus.LOST).count();
        int openBets = (int) bets.stream().filter(b -> b.getStatus() == Bet.BetStatus.OPEN).count();

        int wonPredictions = (int) predictions.stream().filter(p ->
                Boolean.TRUE.equals(p.getSettled()) &&
                Boolean.TRUE.equals(p.getWon())).count();

        int lostPredictions = (int) predictions.stream().filter(p ->
                Boolean.TRUE.equals(p.getSettled()) &&
                Boolean.FALSE.equals(p.getWon())).count();

        int openPredictions = (int) predictions.stream().filter(p -> !Boolean.TRUE.equals(p.getSettled())).count();

        return new UserProfileDTO(
                user.getUsername(),
                user.getCreatedAt(),
                user.isAdmin(),
                bets.size(),
                wonBets,
                lostBets,
                openBets,
                predictions.size(),
                wonPredictions,
                lostPredictions,
                openPredictions
        );

    }

}