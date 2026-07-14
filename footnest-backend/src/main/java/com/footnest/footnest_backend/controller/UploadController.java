package com.footnest.footnest_backend.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.footnest.footnest_backend.service.UploadService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/uploads")
@CrossOrigin
@RequiredArgsConstructor
public class UploadController {

    private final UploadService uploadService;


    @PostMapping("/team-logo")
    public ResponseEntity<?> uploadTeamLogo(
            @RequestParam("file") MultipartFile file,
            @RequestParam("competitionSeasonId") Long competitionSeasonId
    ) throws IOException {

        String path = uploadService.uploadTeamLogo(file, competitionSeasonId);

        return ResponseEntity.ok(Map.of("logoPath", path));
    }

}