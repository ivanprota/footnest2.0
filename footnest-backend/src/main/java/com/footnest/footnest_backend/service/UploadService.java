package com.footnest.footnest_backend.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.exception.ResourceNotFoundException;
import com.footnest.footnest_backend.repository.CompetitionSeasonRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UploadService {

    private final CompetitionSeasonRepository competitionSeasonRepository;
    private final String BASE_PATH = "uploads/teams";

    public String uploadTeamLogo(MultipartFile file, Long competitionSeasonId) throws IOException {
        CompetitionSeason competitionSeason =
                competitionSeasonRepository.findById(competitionSeasonId)
                .orElseThrow(() ->
                    new ResourceNotFoundException(
                        "CompetitionSeason non trovata con id: "
                        + competitionSeasonId
                    )
                );

        String competitionFolder =
                competitionSeason
                    .getCompetition()
                    .getName()
                    .toLowerCase()
                    .replace(" ", "-");

        File folder = new File(BASE_PATH + "/" + competitionFolder);

        if(!folder.exists()) {
            folder.mkdirs();
        }

        String filename = file.getOriginalFilename();

        Path path = Path.of(folder.getPath(), filename);

        Files.copy(
                file.getInputStream(),
                path,
                StandardCopyOption.REPLACE_EXISTING
        );

        return "teams/"
                + competitionFolder
                + "/"
                + filename;
    }
}