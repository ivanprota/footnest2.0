import 'package:flutter/material.dart';

import '../../models/competitionseason/competition_season.dart';

class SeasonSelector extends StatelessWidget {

  final List<CompetitionSeason> seasons;

  final CompetitionSeason? selectedSeason;

  final ValueChanged<CompetitionSeason?> onChanged;

  const SeasonSelector({
    super.key,
    required this.seasons,
    required this.selectedSeason,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Stagione",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        DropdownButton<CompetitionSeason>(
          isExpanded: true,
          value: selectedSeason,
          items: seasons.map((season) {
            return DropdownMenuItem(
              value: season,
              child: Text(
                season.seasonName,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),

      ],
    );
  }

}