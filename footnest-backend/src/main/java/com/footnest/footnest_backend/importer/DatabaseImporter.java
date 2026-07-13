package com.footnest.footnest_backend.importer;

import java.io.File;
import java.time.LocalDate;
import java.util.Optional;

import org.springframework.boot.CommandLineRunner;
//import org.springframework.stereotype.Component;

import com.footnest.footnest_backend.entity.Competition;
import com.footnest.footnest_backend.entity.Competition.CompetitionType;
import com.footnest.footnest_backend.entity.CompetitionSeason;
import com.footnest.footnest_backend.entity.Season;
import com.footnest.footnest_backend.entity.Standing;
import com.footnest.footnest_backend.entity.Team;
import com.footnest.footnest_backend.entity.TeamCompetition;
import com.footnest.footnest_backend.repository.CompetitionRepository;
import com.footnest.footnest_backend.repository.CompetitionSeasonRepository;
import com.footnest.footnest_backend.repository.SeasonRepository;
import com.footnest.footnest_backend.repository.StandingRepository;
import com.footnest.footnest_backend.repository.TeamCompetitionRepository;
import com.footnest.footnest_backend.repository.TeamRepository;

import lombok.RequiredArgsConstructor;

//@Component
@RequiredArgsConstructor
public class DatabaseImporter implements CommandLineRunner {

    private final TeamRepository teamRepository;
    private final CompetitionRepository competitionRepository;
    private final SeasonRepository seasonRepository;
    private final CompetitionSeasonRepository competitionSeasonRepository;
    private final TeamCompetitionRepository teamCompetitionRepository;
    private final StandingRepository standingRepository;

    private final String BASE_PATH = "uploads/teams";

    @Override
    public void run(String... args) throws Exception {
        importTeams();
    }

    private void importTeams() {
        Season season = createSeason();

        File baseFolder = new File(BASE_PATH);

        if (!baseFolder.exists()) {
            System.out.println("Cartella import non trovata: " + BASE_PATH);
            return;
        }

        File[] competitions = baseFolder.listFiles(File::isDirectory);

        if (competitions == null) {
            return;
        }

        for (File competitionFolder : competitions) {
            String folderName = competitionFolder.getName();
            Competition competition = createCompetition(folderName);
            CompetitionSeason competitionSeason = createCompetitionSeason(competition, season);

            importTeamsFromFolder(competitionFolder, competitionSeason, season);
        }
    }

    private Season createSeason() {
        Optional<Season> existing = seasonRepository.findByName("2025/2026");

        if(existing.isPresent()) {
            return existing.get();
        }

        Season season = new Season();
        season.setName("2025/2026");
        season.setStartDate(LocalDate.of(2025,8,1));
        season.setEndDate(LocalDate.of(2026,5,31));

        return seasonRepository.save(season);
    }

    private Competition createCompetition(String folderName) {
        String name = formatName(folderName);
        Optional<Competition> existing = competitionRepository.findByName(name);

        if(existing.isPresent()) {
            return existing.get();
        }

        Competition competition = new Competition();
        competition.setName(name);
        competition.setLogoPath(
            "teams/"
            + folderName
            + "/"
            + folderName
            + ".png"
        );
        competition.setType(CompetitionType.LEAGUE);

        return competitionRepository.save(competition);
    }

    private CompetitionSeason createCompetitionSeason(Competition competition, Season season) {
        return competitionSeasonRepository.findByCompetitionAndSeason(competition, season)
                .orElseGet(() -> {
                    CompetitionSeason cs = new CompetitionSeason();
                    cs.setCompetition(competition);
                    cs.setSeason(season);

                    return competitionSeasonRepository.save(cs);
                });
    }

    private void importTeamsFromFolder(File folder, CompetitionSeason competitionSeason, Season season) {
        File[] files = folder.listFiles();
        
        if(files == null)
            return;

        for(File file : files) {
            String filename = file.getName();

            // ignora logo campionato
            if(filename.equalsIgnoreCase(folder.getName()+".png")) {
                continue;
            }

            if(!filename.endsWith(".png")) {
                continue;
            }

            String teamName = formatName(filename.replace(".png", ""));

            Team team = teamRepository.findByName(teamName)
                    .orElseGet(() -> {
                        Team newTeam = new Team();
                        newTeam.setName(teamName);
                        newTeam.setLogoPath(
                            "teams/"
                            + folder.getName()
                            + "/"
                            + filename
                        );

                        return teamRepository.save(newTeam);
                    });

            TeamCompetition tc = new TeamCompetition();
            tc.setTeam(team);
            tc.setCompetitionSeason(competitionSeason);
            tc.setSeason(season);
            teamCompetitionRepository.save(tc);

            Optional<Standing> existingStanding =
                standingRepository.findByTeamIdAndCompetitionSeasonId(team.getId(), competitionSeason.getId());

            if(existingStanding.isEmpty()) {
                Standing standing = new Standing();
                standing.setTeam(team);
                standing.setCompetitionSeason(competitionSeason);
                standing.setPlayed(0);
                standing.setWins(0);
                standing.setDraws(0);
                standing.setLosses(0);
                standing.setGoalsFor(0);
                standing.setGoalsAgainst(0);
                standing.setPoints(0);
                standing.setTotalXg(0.0);

                standingRepository.save(standing);

            }
        }
    }

    private String formatName(String value) {
        String[] words = value.replace("-", " ").split(" ");

        StringBuilder result = new StringBuilder();

        for(String word : words) {
            if(word.isEmpty())
                continue;

            result.append(word.substring(0,1).toUpperCase());
            result.append(word.substring(1).toLowerCase());
            result.append(" ");
        }

        return result.toString().trim();
    }
}