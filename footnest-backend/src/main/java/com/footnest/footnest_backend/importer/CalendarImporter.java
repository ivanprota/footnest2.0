package com.footnest.footnest_backend.importer;

import lombok.RequiredArgsConstructor;

import org.apache.commons.csv.*;

import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.entity.*;
import com.footnest.footnest_backend.repository.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.time.LocalDate;

@Component
@RequiredArgsConstructor
public class CalendarImporter {


    private final TeamRepository teamRepository;
    private final FootballMatchRepository footballMatchRepository;
    private final CompetitionRepository competitionRepository;
    private final SeasonRepository seasonRepository;
    private final CompetitionSeasonRepository competitionSeasonRepository;
    private final TeamCompetitionRepository teamCompetitionRepository;
    private final TeamNameMapper teamNameMapper;

    public void importCsv(
            String filePath,
            String competitionName,
            String seasonName
    ) throws IOException {

        System.out.println(
            "Import calendario: "
            + competitionName
            + " "
            + seasonName
        );

        Competition competition =
                competitionRepository
                        .findByName(competitionName)
                        .orElseThrow();

        Season season =
                seasonRepository
                        .findByName(seasonName)
                        .orElseThrow();

        CompetitionSeason competitionSeason =
                competitionSeasonRepository
                        .findByCompetitionAndSeason(
                                competition,
                                season
                        )
                        .orElseThrow();

        try (
            Reader reader =
                    Files.newBufferedReader(
                            Paths.get(filePath),
                            StandardCharsets.UTF_8
                    );

            CSVParser csv =
                    CSVFormat.DEFAULT
                            .builder()
                            .setHeader()
                            .setSkipHeaderRecord(true)
                            .build()
                            .parse(reader)
        ) {

            int imported = 0;
            for(CSVRecord row : csv) {
                LocalDate date =
                        LocalDate.parse(
                                row.get("date")
                        );

                Integer matchday =
                        Integer.parseInt(
                                row.get("matchday")
                        );

                String homeName =
                        teamNameMapper.normalize(
                                row.get("home_team")
                        );

                String awayName =
                        teamNameMapper.normalize(
                                row.get("away_team")
                        );


                Team homeTeam =
                        teamRepository
                                .findByNameIgnoreCase(homeName)
                                .orElseThrow(
                                    () -> new RuntimeException(
                                        "Squadra non trovata: "
                                        + homeName
                                    )
                                );

                Team awayTeam =
                        teamRepository
                                .findByNameIgnoreCase(awayName)
                                .orElseThrow(
                                    () -> new RuntimeException(
                                        "Squadra non trovata: "
                                        + awayName
                                    )
                                );

                if(!teamCompetitionRepository
                        .existsByTeamAndCompetitionSeason(
                                homeTeam,
                                competitionSeason
                        )) {

                    throw new RuntimeException(
                            homeTeam.getName()
                            + " non partecipa alla competizione"
                    );
                }

                if(!teamCompetitionRepository
                        .existsByTeamAndCompetitionSeason(
                                awayTeam,
                                competitionSeason
                        )) {

                    throw new RuntimeException(
                            awayTeam.getName()
                            + " non partecipa alla competizione"
                    );
                }


                FootballMatch match =
                        new FootballMatch();


                match.setCompetitionSeason(
                        competitionSeason
                );


                match.setSeason(
                        season
                );


                match.setHomeTeam(
                        homeTeam
                );


                match.setAwayTeam(
                        awayTeam
                );


                match.setDate(date);

                match.setMatchday(matchday);


                match.setHomeGoals(-1);

                match.setAwayGoals(-1);


                match.setStatus(
                        MatchStatus.SCHEDULED
                );

                if (footballMatchRepository.existsByDateAndHomeTeamAndAwayTeam(
                        date,
                        homeTeam,
                        awayTeam
                )) {
                    System.out.println(
                        "Saltata (già presente): "
                        + homeTeam.getName()
                        + " - "
                        + awayTeam.getName()
                    );
                    continue;
                }

                footballMatchRepository.save(match);


                imported++;


                System.out.println(
                    "Importata: "
                    + homeTeam.getName()
                    + " - "
                    + awayTeam.getName()
                );
            }


            System.out.println(
                "IMPORT COMPLETATO. Partite importate: "
                + imported
            );

        }
    }
}