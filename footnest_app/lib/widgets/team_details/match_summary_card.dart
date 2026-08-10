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

                  Column(
                    children: [

                      Text(
                        DateFormat("dd-MM-yyyy")
                            .format(match.date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      if (match.kickoffTime != null &&
                          match.kickoffTime!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            match.kickoffText,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),

                    ],
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
    return Expanded(
      child: Column(
        children: [
          Image.network(
            logo,
            height: 40,
            width: 40,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return const Icon(
                Icons.shield,
                size: 40,
              );
            },
          ),

          const SizedBox(height: 6),

          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}