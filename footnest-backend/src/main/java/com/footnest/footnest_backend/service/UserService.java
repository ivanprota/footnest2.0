package com.footnest.footnest_backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.footnest.footnest_backend.entity.User;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.UserRepository;

@Service
public class UserService {
    
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

        public List<User> findAll() {
        return userRepository.findAll();
    }

    public User findById(Long id) {
        return userRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Utente non trovato con id: " +id));
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    public User update(Long id, User user) {
        User existing = findById(id);

        existing.setApproved(user.isApproved());
        existing.setAdmin(user.isAdmin());

        return userRepository.save(existing);
    }

    public void delete(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("Utente non trovato con id: " +id);
        }

        userRepository.deleteById(id);
    }

}
