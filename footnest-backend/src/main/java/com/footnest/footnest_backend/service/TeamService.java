package com.footnest.footnest_backend.service;

import com.footnest.footnest_backend.mapper.TeamMapper;
import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.team.TeamDTO;
import com.footnest.footnest_backend.entity.Team;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.TeamRepository;

@Service
public class TeamService {

    private final TeamMapper teamMapper;
    private final TeamRepository teamRepository;

    public TeamService(TeamRepository teamRepository, TeamMapper teamMapper) {
        this.teamRepository = teamRepository;
        this.teamMapper = teamMapper;
    }

    public List<TeamDTO> findAll() {
        return teamRepository.findAll()
                    .stream()
                    .map(teamMapper::toDTO)
                    .toList();
    }

    public Team findById(Long id) {
        return teamRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Squadra non trovata con id: " +id));
    }

    public Team save(Team team) {
        return teamRepository.save(team);
    }

    public Team update(Long id, Team team) {
        Team existing = findById(id);

        existing.setName(team.getName());

        return teamRepository.save(existing);
    }

    public void delete(Long id) {
        if (!teamRepository.existsById(id)) {
            throw new ResourceNotFoundException("Squadra non trovata con id: " +id);
        }

        teamRepository.deleteById(id);
    }
}
