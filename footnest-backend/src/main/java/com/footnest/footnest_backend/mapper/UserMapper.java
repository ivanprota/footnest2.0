package com.footnest.footnest_backend.mapper;

import com.footnest.footnest_backend.dto.user.UserDTO;
import com.footnest.footnest_backend.entity.User;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserDTO toDTO(User user) {

        return new UserDTO(
            user.getId(),
            user.getUsername(),
            user.isApproved(),
            user.isAdmin(),
            user.getCreatedAt()
        );
    }
}
