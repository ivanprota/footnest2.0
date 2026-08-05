import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/match/match_summary.dart';

import 'package:go_router/go_router.dart';
import '/routes/routes.dart';

class MatchSummaryCard extends StatefulWidget {

  final MatchSummary match;

  const MatchSummaryCard({
    super.key,
    required this.match,
  });

  @override
  State<MatchSummaryCard> createState() =>
      _MatchSummaryCardState();

}

class _MatchSummaryCardState extends State<MatchSummaryCard> {

  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final match = widget.match;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: hovered
            ? Matrix4.translationValues(0, -4, 0)
            : Matrix4.identity(),
        child: Card(
          elevation: hovered ? 8 : 2,
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.push('${AppRoutes.matches}/${match.id}');
            },
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
                    DateFormat("dd-MM-yyyy")
                        .format(match.date),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),

                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _team(String name, String logo) {
    return SizedBox(
      width:90,
      child: Column(
        children: [

          Image.network(
            logo,
            height:35,
            width:35,
            errorBuilder: (_,__,___){
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