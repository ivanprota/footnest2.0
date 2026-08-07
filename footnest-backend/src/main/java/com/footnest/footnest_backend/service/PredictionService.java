package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.dto.common.PageResponse;
import com.footnest.footnest_backend.dto.prediction.CreatePredictionRequest;
import com.footnest.footnest_backend.dto.prediction.PredictionDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.MatchStatus;
import com.footnest.footnest_backend.entity.Prediction;
import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.mapper.PredictionMapper;
import com.footnest.footnest_backend.repository.FootballMatchRepository;
import com.footnest.footnest_backend.repository.PredictionRepository;
import com.footnest.footnest_backend.repository.UserRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PredictionService {

    private final PredictionRepository predictionRepository;
    private final UserRepository userRepository;
    private final FootballMatchRepository footballMatchRepository;
    private final PredictionMapper predictionMapper;

    public PredictionService(
        PredictionRepository predictionRepository, 
        UserRepository userRepository,
        FootballMatchRepository footballMatchRepository,
        PredictionMapper predictionMapper
    ) 
    {
        this.predictionRepository = predictionRepository;
        this.userRepository = userRepository;
        this.footballMatchRepository = footballMatchRepository;
        this.predictionMapper = predictionMapper;
    }

    public List<PredictionDTO> findAllByUser(Long userId) {
        return predictionRepository
                .findByUserId(userId)
                .stream()
                .map(predictionMapper::toDTO)
                .toList();
    }

    public List<PredictionDTO> findAllByUsername(String username) {
        User user = userRepository.findByUsername(username)
                        .orElseThrow(() -> new RuntimeException("Utente non trovato"));

        return predictionRepository
                .findByUserId(user.getId())
                .stream()
                .map(predictionMapper::toDTO)
                .toList();
    }

    public List<PredictionDTO> findByMatch(String username, Long matchId) {
        User user = userRepository
                .findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("Utente non trovato")
                );

        return predictionRepository
                .findByUserIdAndMatchId(user.getId(), matchId)
                .stream()
                .map(predictionMapper::toDTO)
                .toList();
    }

        public PageResponse<PredictionDTO> findPage(
                String username,
                int page,
                int size
        ) {

                User user = userRepository
                        .findByUsername(username)
                        .orElseThrow(() ->
                                new RuntimeException("Utente non trovato"));

                Page<Prediction> result =
                        predictionRepository.findByUserIdOrderByCreatedAtDesc(
                                user.getId(),
                                PageRequest.of(page, size)
                        );

                return new PageResponse<>(
                        result.getContent()
                                .stream()
                                .map(predictionMapper::toDTO)
                                .toList(),
                        result.getNumber(),
                        result.getTotalPages(),
                        result.getTotalElements()
                );
        }

    public PredictionDTO savePrediction(String username, CreatePredictionRequest request) {
        User user = userRepository
                .findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("Utente non trovato")
                );

        FootballMatch match = footballMatchRepository
                .findById(request.getMatchId())
                .orElseThrow(() ->
                        new RuntimeException("Partita non trovata")
                );

        if(match.getStatus() == MatchStatus.PLAYED) {
                throw new RuntimeException("Non puoi inserire pronostici su partite concluse");
        }

        Prediction prediction = new Prediction();

        prediction.setUser(user);
        prediction.setMatch(match);
        prediction.setPrediction(request.getPrediction());
        prediction.setOdd(request.getOdd());

        Prediction saved = predictionRepository.save(prediction);

        return predictionMapper.toDTO(saved);
    }

    public void deletePrediction(Long predictionId, String username) {
        Prediction prediction =
                predictionRepository.findById(predictionId)
                        .orElseThrow(() ->
                                new RuntimeException("Pronostico non trovato")
                        );

        if (!prediction.getUser()
                .getUsername()
                .equals(username)) {

            throw new RuntimeException("Operazione non consentita");
        }

        predictionRepository.delete(prediction);
    }
}