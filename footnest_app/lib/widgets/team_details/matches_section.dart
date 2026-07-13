import 'package:flutter/material.dart';

import '/models/match/match_summary.dart';
import 'match_summary_card.dart';

class MatchesSection extends StatelessWidget {

  final String title;
  final List<MatchSummary> matches;

  const MatchesSection({
    super.key,
    required this.title,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize:20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:12),

            if(matches.isEmpty)
              const Text(
                "Nessuna partita disponibile",
              )
            else
              Column(
                children:

                  matches
                    .map(
                      (match) =>
                          MatchSummaryCard(
                            match: match,
                          ),
                    )
                    .toList(),
              )

          ],

        ),

      ),

    );

  }

}