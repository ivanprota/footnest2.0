import 'package:flutter/material.dart';

import '/models/team/team_details.dart';

class TeamHeaderCard extends StatelessWidget {

  final TeamDetails team;

  const TeamHeaderCard({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [

            Image.network(
              team.logoPath,
              height: 90,
              width: 90,
              errorBuilder: (_,__,___){
                return const Icon(
                  Icons.shield,
                  size:90,
                );
              },
            ),

            const SizedBox(width:25),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  team.name,
                  style: const TextStyle(
                    fontSize:28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height:12),

                Wrap(
                  spacing:8,
                  children:
                      team.competitions
                      .map(
                        (c) => Chip(
                          label: Text(
                            "${c.competitionName} "
                            "${c.seasonName}",
                          ),
                        ),
                      )
                      .toList(),
                )

              ],
            )

          ],
        ),

      ),

    );

  }

}