package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.dto.common.PageResponse;
import com.footnest.footnest_backend.dto.prediction.CreatePredictionRequest;
import com.footnest.footnest_backend.dto.prediction.PredictionDTO;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.MatchStatus;
import com.footnest.footnest_backend.entity.Prediction;
import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.entity.Bet;
import com.footnest.footnest_backend.entity.BetSelection;
import com.footnest.footnest_backend.repository.BetRepository;
import org.springframework.transaction.annotation.Transactional;
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
    private final BetRepository betRepository;

    public PredictionService(
        PredictionRepository predictionRepository, 
        UserRepository userRepository,
        FootballMatchRepository footballMatchRepository,
        PredictionMapper predictionMapper,
        BetRepository betRepository
    ) 
    {
        this.predictionRepository = predictionRepository;
        this.userRepository = userRepository;
        this.footballMatchRepository = footballMatchRepository;
        this.predictionMapper = predictionMapper;
        this.betRepository = betRepository;
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

    public PageResponse<PredictionDTO> findPage(String username, int page, int size) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Utente non trovato"));

        Page<Prediction> result = predictionRepository.findByUserIdOrderByCreatedAtDesc(user.getId(), PageRequest.of(page, size));

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

        @Transactional
        public PredictionDTO updateStatus(
                Long predictionId,
                Boolean settled,
                Boolean won,
                String username
        ) {

        Prediction prediction =
                predictionRepository.findById(predictionId)
                .orElseThrow(() ->
                        new RuntimeException("Pronostico non trovato")
                );


        if (!prediction.getUser().getUsername().equals(username)) {
                throw new RuntimeException("Operazione non consentita");
        }

        prediction.setSettled(settled);


        if(settled) {
                prediction.setWon(won);
        }
        else {
                prediction.setWon(null);
        }


        Prediction saved =
                predictionRepository.save(prediction);



        for(BetSelection selection : prediction.getSelections()) {

                updateBetStatus(
                selection.getBet()
                );

        }


        return predictionMapper.toDTO(saved);
        }

        public PageResponse<PredictionDTO> findPageByUserId(
                Long userId,
                int page,
                int size
        ) {

        Page<Prediction> result =
                predictionRepository.findByUserIdOrderByCreatedAtDesc(
                        userId,
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

        private void updateBetStatus(Bet bet) {

        List<BetSelection> selections = bet.getSelections();


        boolean hasLost = selections.stream()
                .anyMatch(selection ->
                        Boolean.TRUE.equals(
                                selection.getPrediction().getSettled()
                        )
                        &&
                        Boolean.FALSE.equals(
                                selection.getPrediction().getWon()
                        )
                );


        boolean allWon = selections.stream()
                .allMatch(selection ->
                        Boolean.TRUE.equals(
                                selection.getPrediction().getSettled()
                        )
                        &&
                        Boolean.TRUE.equals(
                                selection.getPrediction().getWon()
                        )
                );


        if(hasLost) {

                bet.setStatus(
                Bet.BetStatus.LOST
                );

        }
        else if(allWon) {

                bet.setStatus(
                Bet.BetStatus.WON
                );

        }
        else {

                bet.setStatus(
                Bet.BetStatus.OPEN
                );

        }


        betRepository.save(bet);
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

        if (predictionRepository.existsInBet(predictionId)) {
                throw new RuntimeException(
                        "Questo pronostico è presente in una o più schedine. Elimina prima le schedine che lo contengono."
                );
        }

        predictionRepository.delete(prediction);
    }
}