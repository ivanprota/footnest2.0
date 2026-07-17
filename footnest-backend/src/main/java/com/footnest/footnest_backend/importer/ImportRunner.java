package com.footnest.footnest_backend.importer;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ImportRunner implements CommandLineRunner {

    private final CalendarImporter calendarImporter;


    @Override
    public void run(String... args) throws Exception {

        calendarImporter.importCsv(
            "C:/la-liga-es_2026-27.csv",
            "La Liga",
            "2026/2027"
        );
    }

}