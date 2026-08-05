package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.footnest.footnest_backend.dto.bet.BetDTO;
import com.footnest.footnest_backend.dto.bet.CreateBetRequest;
import com.footnest.footnest_backend.entity.Bet;
import com.footnest.footnest_backend.entity.BetSelection;
import com.footnest.footnest_backend.entity.FootballMatch;
import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.mapper.BetMapper;
import com.footnest.footnest_backend.repository.BetRepository;
import com.footnest.footnest_backend.repository.FootballMatchRepository;
import com.footnest.footnest_backend.repository.UserRepository;

@Service
public class BetService {
    
    private final BetRepository betRepository;
    private final UserRepository userRepository;
    private final FootballMatchRepository footballMatchRepository;
    private final BetMapper betMapper;

    public BetService(
        BetRepository betRepository,
        UserRepository userRepository,
        FootballMatchRepository footballMatchRepository,
        BetMapper betMapper
    ) 
    {
        this.betRepository = betRepository;
        this.userRepository = userRepository;
        this.footballMatchRepository = footballMatchRepository;
        this.betMapper = betMapper;
    }

    public List<BetDTO> findAll(String username){

        User user =
                userRepository
                .findByUsername(username)
                .orElseThrow();


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

    public List<BetDTO> findByUsername(String username) {

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("Utente non trovato"));

        return betRepository
                .findByUserIdOrderByCreatedAtDesc(user.getId())
                .stream()
                .map(betMapper::toDTO)
                .toList();
    }

    public Bet save(Bet bet) {
        return betRepository.save(bet);
    }

    @Transactional
    public BetDTO create(
            String username,
            CreateBetRequest request
    ){

        User user =
                userRepository
                .findByUsername(username)
                .orElseThrow();


        Bet bet = new Bet();

        bet.setUser(user);
        bet.setName(request.getName());


        List<BetSelection> selections =
                request.getSelections()
                .stream()
                .map(selectionRequest -> {


                    FootballMatch match =
                            footballMatchRepository
                            .findById(
                                selectionRequest.getMatchId()
                            )
                            .orElseThrow();


                    BetSelection selection =
                            new BetSelection();


                    selection.setBet(bet);

                    selection.setMatch(match);

                    selection.setPrediction(
                        selectionRequest.getPrediction()
                    );

                    selection.setOdd(
                        selectionRequest.getOdd()
                    );


                    return selection;


                })
                .toList();


        bet.setSelections(selections);


        return betMapper.toDTO(
                betRepository.save(bet)
        );

    }

    public Bet update(Long id, Bet bet) {
        Bet existing = findById(id);

        existing.setName(bet.getName());
        existing.setStatus(bet.getStatus());

        return betRepository.save(existing);
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
