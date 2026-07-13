import 'package:flutter/material.dart';

import '/models/standing/standing.dart';

class StandingCard extends StatelessWidget {

  final Standing standing;

  const StandingCard({
    super.key,
    required this.standing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Classifica",
                  style: TextStyle(
                    fontSize:20,
                    fontWeight:FontWeight.bold,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${standing.position}°",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )
                  )
                )
              
              ],
            ),

            const SizedBox(height:20),

            _row(
              "Partite",
              standing.played.toString(),
            ),

            _row(
              "Vittorie",
              standing.wins.toString(),
            ),

            _row(
              "Pareggi",
              standing.draws.toString(),
            ),

            _row(
              "Sconfitte",
              standing.losses.toString(),
            ),

            const Divider(),

            _row(
              "Gol fatti",
              standing.goalsFor.toString(),
            ),

            _row(
              "Gol subiti",
              standing.goalsAgainst.toString(),
            ),

            _row(
              "Punti",
              standing.points.toString(),
            ),

            _row(
              "xG",
              standing.totalXg.toStringAsFixed(2),
            ),

          ],

        ),

      ),

    );

  }

  Widget _row(String label, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(label),

          Text(
            value,
            style: const TextStyle(
              fontWeight:FontWeight.bold,
            ),
          ),

        ],

      ),

    );

  }

}