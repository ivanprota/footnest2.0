import 'package:flutter/material.dart';

import '/models/match/competition_matches.dart';
import '/config/api_config.dart';
import 'match_row.dart';

class CompetitionMatchesTile extends StatefulWidget {

  final CompetitionMatches competition;

  const CompetitionMatchesTile({
    super.key,
    required this.competition,
  });

  @override
  State<CompetitionMatchesTile> createState() =>
      _CompetitionMatchesTileState();

}


class _CompetitionMatchesTileState extends State<CompetitionMatchesTile> {

  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [

          BoxShadow(
            blurRadius: 8,
            offset: Offset(0,3),
            color: Colors.black12,
          )

        ],
      ),
      child: Column(
        children: [

          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal:16,
                    vertical:12,
                  ),
              child: Row(
                children: [

                  // LOGO COMPETIZIONE
                  Image.network(
                    "${ApiConfig.baseUrl}/${widget.competition.competitionLogo}",
                    width:32,
                    height:32,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(strokeWidth: 2,)
                      );
                    },
                    errorBuilder: (_,__,___) =>
                        const Icon(
                          Icons.emoji_events,
                          size:32,
                        ),
                  ),

                  const SizedBox(width:12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[

                        Text(
                          widget.competition.competitionName,
                          style: Theme.of(context).textTheme.titleMedium
                        ),

                        Text(
                          "${widget.competition.matches.length} partite",
                          style: TextStyle(
                            fontSize:12,
                            color: Colors.grey[600],
                          ),
                        )

                      ],
                    ),
                  ),

                  AnimatedRotation(
                    turns: expanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),

                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: expanded
                ? Column(
                    children:
                        widget.competition.matches
                            .map(
                              (match) => MatchRow(
                                match: match,
                              ),
                            )
                            .toList(),
                  )
                : const SizedBox.shrink(),
          )

        ],
      ),
    );
  }

}