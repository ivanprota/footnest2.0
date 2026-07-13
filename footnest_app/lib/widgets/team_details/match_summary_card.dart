import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/match/match_summary.dart';

class MatchSummaryCard extends StatelessWidget {

  final MatchSummary match;

  const MatchSummaryCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                _team(
                  match.homeTeam,
                  match.homeLogo,
                ),

                Column(
                  children: [

                    if(match.status == "PLAYED")
                      Text(
                        "${match.homeGoals ?? '-'}"
                        " - "
                        "${match.awayGoals ?? '-'}",
                        style: const TextStyle(
                          fontSize:22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        "VS",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                  ],
                ),

                _team(
                  match.awayTeam,
                  match.awayLogo,
                ),

              ],
            ),

            const SizedBox(height:10),

            Text(
              DateFormat("dd-MM-yyyy").format(match.date),
              style: TextStyle(
                color:
                    Colors.grey[600],
              ),
            )

          ],
        ),
      ),
    );

  }

  Widget _team(String name, String logo){
    return SizedBox(
      width:90,
      child: Column(
        children: [

          Image.network(
            logo,
            height:35,
            width:35,
            errorBuilder:
              (_,__,___){
                return const Icon(
                  Icons.shield,
                  size:35,
                );
              },
          ),

          const SizedBox(height:5),

          Text(
            name,
            maxLines:1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

        ],
      ),

    );

  }

}