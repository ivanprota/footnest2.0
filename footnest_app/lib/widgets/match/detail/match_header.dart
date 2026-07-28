import 'package:flutter/material.dart';

import '/models/match/match_detail.dart';
import 'team_logo_box.dart';

class MatchHeader extends StatelessWidget {

  final MatchDetail match;

  const MatchHeader({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [

            theme.colorScheme.primary
                .withOpacity(0.20),

            theme.colorScheme.surface,

          ],

        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
            theme.colorScheme.outline
                .withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [

          // COMPETIZIONE
          Container(
            padding:
              const EdgeInsets.symmetric(
                horizontal:14,
                vertical:6,
              ),
            decoration: BoxDecoration(
              color:
                theme.colorScheme.primary
                    .withOpacity(0.15),
              borderRadius:
                BorderRadius.circular(20),
            ),
            child: Text(
              match.competition,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                ),
            ),
          ),

          const SizedBox(height:10),

          Text(
            "${match.season}  •  Giornata ${match.matchday}",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize:14,
              ),
          ),

          const SizedBox(height:35),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                child: TeamLogoBox(
                  name: match.homeTeam,
                  logo: match.homeLogo,
                ),
              ),

              Container(
                margin:
                  const EdgeInsets.symmetric(
                    horizontal:10,
                  ),
                child: Column(
                  children: [

                    Text(
                      "VS",
                      style: TextStyle(
                        fontSize:26,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                        ),
                    ),

                    const SizedBox(height:8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal:10,
                        vertical:4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius:BorderRadius.circular(12),
                        ),
                      child: Text(
                        match.status,
                        style: const TextStyle(
                          fontSize:11,
                          fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: TeamLogoBox(
                  name: match.awayTeam,
                  logo: match.awayLogo,
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
  
}