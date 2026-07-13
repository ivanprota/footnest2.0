package com.footnest.footnest_backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class AppConfig {

    @Value("${app.base-url}")
    private String baseUrl;

}