package com.footnest.footnest_backend.dto.footballmatch;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;

import com.footnest.footnest_backend.entity.MatchStatus;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMatchRequest {

    private LocalDate date;

    private LocalTime kickoffTime;

    private Integer homeGoals;

    private Integer awayGoals;

    private MatchStatus status;

}
