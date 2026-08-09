package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import com.footnest.footnest_backend.dto.bet.BetDTO;
import com.footnest.footnest_backend.dto.bet.CreateBetRequest;
import com.footnest.footnest_backend.dto.common.PageResponse;
import com.footnest.footnest_backend.entity.Bet;
import com.footnest.footnest_backend.entity.BetSelection;
import com.footnest.footnest_backend.entity.Prediction;
import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.mapper.BetMapper;
import com.footnest.footnest_backend.repository.BetRepository;
import com.footnest.footnest_backend.repository.PredictionRepository;
import com.footnest.footnest_backend.repository.UserRepository;

@Service
public class BetService {
    
    private final BetRepository betRepository;
    private final UserRepository userRepository;
    private final PredictionRepository predictionRepository;
    private final BetMapper betMapper;

    public BetService(
        BetRepository betRepository,
        UserRepository userRepository,
        PredictionRepository predictionRepository,
        BetMapper betMapper
    ) 
    {
        this.betRepository = betRepository;
        this.userRepository = userRepository;
        this.predictionRepository = predictionRepository;
        this.betMapper = betMapper;
    }

    public List<BetDTO> findAll(String username) {
        User user = userRepository.findByUsername(username).orElseThrow();

        return betRepository
                .findByUserId(user.getId())
                .stream()
                .map(betMapper::toDTO)
                .toList();

    }

    public Bet findById(Long id) {
        return betRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Schedina non trovata con id: " +id));
    }

    public Bet save(Bet bet) {
        return betRepository.save(bet);
    }

    public PageResponse<BetDTO> findPage(String username, int page, int size) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Utente non trovato"));

        Page<Bet> result = betRepository.findByUserIdOrderByCreatedAtDesc(
                        user.getId(),
                        PageRequest.of(page, size)
                );

        return new PageResponse<>(
                result.getContent()
                        .stream()
                        .map(betMapper::toDTO)
                        .toList(),
                result.getNumber(),
                result.getTotalPages(),
                result.getTotalElements()
        );
    }

    public PageResponse<BetDTO> findPageByUserId(Long userId, int page, int size) {
        Page<Bet> result = betRepository.findByUserIdOrderByCreatedAtDesc(userId, PageRequest.of(page, size));

        return new PageResponse<>(
                result.getContent()
                        .stream()
                        .map(betMapper::toDTO)
                        .toList(),
                result.getNumber(),
                result.getTotalPages(),
                result.getTotalElements()
        );
    }

    @Transactional
    public BetDTO create(String username, CreateBetRequest request){
        User user = userRepository.findByUsername(username).orElseThrow();

        Bet bet = new Bet();
        bet.setUser(user);
        bet.setName(request.getName());

        List<BetSelection> selections = request.getSelections()
                .stream()
                .map(selectionRequest -> {

                    Prediction prediction =
                        predictionRepository.findById(
                            selectionRequest.getPredictionId()
                        ).orElseThrow();

                    if (!prediction.getUser().getId().equals(user.getId())) {
                        throw new RuntimeException("Non puoi inserire il pronostico di un altro utente");
                    }

                    BetSelection selection = new BetSelection();
                    selection.setBet(bet);
                    selection.setPrediction(prediction);

                    return selection;
                }).toList();

        bet.setSelections(selections);

        return betMapper.toDTO(
                betRepository.save(bet)
        );
    }

    public void deleteBet(Long id, String username) {

        Bet bet = betRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Schedina non trovata"));

        if (!bet.getUser().getUsername().equals(username)) {
            throw new RuntimeException("Operazione non consentita");
        }

        betRepository.delete(bet);
    }

}
