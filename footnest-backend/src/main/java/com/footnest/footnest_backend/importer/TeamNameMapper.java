package com.footnest.footnest_backend.importer;

import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;


@Component
public class TeamNameMapper {


    private final Map<String,String> aliases = new HashMap<>();


    public TeamNameMapper() {

        aliases.put("Como", "Como 1907");
        aliases.put("AC Milan", "Milan");
        aliases.put("AS Roma", "Roma");
        aliases.put("Coventry", "Coventry City");
        aliases.put("Leeds", "Leeds United");
        aliases.put("Bayern München", "Bayern Munich");
        aliases.put("SC Freiburg", "Freiburg");
        aliases.put("Borussia Mönchengladbach", "Borussia Monchengladbach");
        aliases.put("1. FC Köln", "Koln");
        aliases.put("FSV Mainz 05", "Mainz 05");
        aliases.put("SC Paderborn 07", "Paderborn");
        aliases.put("FC Augsburg", "Augsburg");
        aliases.put("FC Schalke 04", "Schalke 04");
        aliases.put("1899 Hoffenheim", "Hoffenheim");
        aliases.put("Alaves", "Deportivo Alaves");

    }


    public String normalize(String csvName) {

        return aliases.getOrDefault(
                csvName,
                csvName
        );
    }

}