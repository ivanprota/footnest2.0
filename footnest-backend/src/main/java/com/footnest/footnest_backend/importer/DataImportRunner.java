package com.footnest.footnest_backend.importer;


import lombok.RequiredArgsConstructor;

import org.springframework.boot.CommandLineRunner;
//import org.springframework.stereotype.Component;


//@Component
@RequiredArgsConstructor
public class DataImportRunner implements CommandLineRunner {


    private final DatabaseImporter databaseImporter;

    private final CalendarImporter calendarImporter;



    @Override
    public void run(String... args) throws Exception {


        System.out.println("==============================");
        System.out.println(" AVVIO IMPORT DATABASE ");
        System.out.println("==============================");


        databaseImporter.importTeams();



        System.out.println("==============================");
        System.out.println(" IMPORT CALENDARI ");
        System.out.println("==============================");


        calendarImporter.importCsv(
                "C:/serie-a-it_2026-27.csv",
                "Serie A",
                "2026/2027"
        );


        calendarImporter.importCsv(
                "C:/premier-league-gb-eng_2026-27.csv",
                "Premier League",
                "2026/2027"
        );


        calendarImporter.importCsv(
                "C:/bundesliga-de_2026-27.csv",
                "Bundesliga",
                "2026/2027"
        );


        calendarImporter.importCsv(
                "C:/la-liga-es_2026-27.csv",
                "La Liga",
                "2026/2027"
        );


        System.out.println("==============================");
        System.out.println(" IMPORT COMPLETATO ");
        System.out.println("==============================");

    }

}