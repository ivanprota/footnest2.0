package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.dto.user.UserDTO;
import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.mapper.UserMapper;
import com.footnest.footnest_backend.repository.UserRepository;

@Service
public class UserService {
    
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserService(UserRepository userRepository, UserMapper userMapper) {
        this.userRepository = userRepository;
        this.userMapper = userMapper;
    }

    public List<UserDTO> findAll() {
        return userRepository.findAll()
                    .stream()
                    .map(userMapper::toDTO)
                    .toList();
    }

    public UserDTO findById(Long id) {
        User user = userRepository.findById(id)
                        .orElseThrow(() -> new ResourceNotFoundException("Utente non trovato con id: " +id));
        
        return userMapper.toDTO(user);
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    public UserDTO updateApproval(Long id, boolean approved) {
        User user = userRepository.findById(id)
                        .orElseThrow(() -> new ResourceNotFoundException("Utente non trovato con id: " +id));

        user.setApproved(approved);
        User saved = userRepository.save(user);
        return userMapper.toDTO(saved);
    }

    public void delete(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("Utente non trovato con id: " +id);
        }

        userRepository.deleteById(id);
    }

}
