package com.footnest.footnest_backend.dto.user;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class UserDTO {

    private Long id;
    private String username;
    private boolean approved;
    private boolean admin;
    private LocalDateTime createdAt;
}
