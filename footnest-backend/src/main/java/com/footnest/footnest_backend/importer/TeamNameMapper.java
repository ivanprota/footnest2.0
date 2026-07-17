package com.footnest.footnest_backend.importer;

import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class TeamNameMapper {


    private final Map<String, String> aliases = Map.of(
            // "Como", "Como 1907",
            // "AC Milan", "Milan",
            // "AS Roma", "Roma",
            // "Coventry", "Coventry City",
            // "Leeds", "Leeds United",
            // "Bayern München", "Bayern Munich",
            // "SC Freiburg", "Freiburg",
            // "Borussia Mönchengladbach", "Borussia Monchengladbach",
            // "1. FC Köln", "Koln",
            // "FSV Mainz 05", "Mainz 05",
            // "FC Augsburg", "Augsburg",
            // "SC Paderborn 07", "Paderborn",
            // "FC Schalke 04", "Schalke 04",
            // "1899 Hoffenheim", "Hoffenheim"
            "Alaves", "Deportivo Alaves"
    );


    public String normalize(String csvName) {

        return aliases.getOrDefault(
                csvName,
                csvName
        );
    }
}