import 'package:flutter/material.dart';

import '/models/match/match_summary.dart';
import 'match_summary_card.dart';

class MatchesSection extends StatelessWidget {

  final String title;
  final List<MatchSummary> matches;
  final int? teamId;

  const MatchesSection({
    super.key,
    required this.title,
    required this.matches,
    this.teamId
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "${matches.length}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],

            ),

            const SizedBox(height: 12),

            matches.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "Nessuna partita disponibile",
                      ),
                    ),
                  )
                : Column(
                    children: [

                      for(final match in matches)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom:8),
                          child: MatchSummaryCard(
                            match: match,
                            teamId: teamId,
                          ),
                        ),

                    ],
                  ),

          ],

        ),
      ),
    );
  }
}