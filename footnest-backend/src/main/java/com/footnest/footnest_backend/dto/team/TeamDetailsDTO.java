package com.footnest.footnest_backend.dto.team;

import lombok.*;
import java.util.List;

import com.footnest.footnest_backend.dto.footballmatch.MatchSummaryDTO;
import com.footnest.footnest_backend.dto.standing.StandingDTO;
import com.footnest.footnest_backend.dto.teamcompetition.TeamCompetitionDTO;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TeamDetailsDTO {

    private Long id;
    private String name;
    private String logoPath;
    private List<TeamCompetitionDTO> competitions;
    private StandingDTO standing;
    private List<MatchSummaryDTO> lastMatches;
    private List<MatchSummaryDTO> nextMatches;

}