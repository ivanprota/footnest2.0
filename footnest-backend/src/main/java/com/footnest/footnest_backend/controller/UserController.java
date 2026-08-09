package com.footnest.footnest_backend.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.footnest.footnest_backend.dto.user.UserDTO;
import com.footnest.footnest_backend.service.UserService;

@RestController
@RequestMapping("/users")
@CrossOrigin
public class UserController {
    
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<UserDTO> getAll() {
        return userService.findAll();
    }

    @GetMapping("/{id}")
    public UserDTO getById(@PathVariable Long id) {
        return userService.findById(id);
    }

    @PutMapping("/{id}/approval")
    public UserDTO updateApproval(@PathVariable Long id, @RequestBody Map<String, Boolean> body) {
        return userService.updateApproval(id, body.get("approved"));
    }

}
