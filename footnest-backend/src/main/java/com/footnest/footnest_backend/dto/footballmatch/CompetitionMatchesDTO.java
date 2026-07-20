package com.footnest.footnest_backend.dto.footballmatch;

import java.util.List;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompetitionMatchesDTO {

    private Long competitionSeasonId;
    private String competitionName;
    private String competitionLogo;
    private List<MatchSummaryDTO> matches;

}
