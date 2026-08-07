import 'package:flutter/material.dart';

import '/models/bet/bet.dart';
import '/config/api_config.dart';

class BetPreviewTile extends StatefulWidget {

  final Bet bet;

  const BetPreviewTile({
    super.key,
    required this.bet,
  });

  @override
  State<BetPreviewTile> createState() => _BetPreviewTileState();

}

class _BetPreviewTileState extends State<BetPreviewTile> {

  bool hovered = false;

  Color getStatusColor() {
    switch(widget.bet.status) {

      case "WON":
        return Colors.green;

      case "LOST":
        return Colors.red;

      default:
        return Colors.orange;

    }
  }

  IconData getStatusIcon() {
    switch(widget.bet.status) {

      case "WON":
        return Icons.check_circle;

      case "LOST":
        return Icons.cancel;

      default:
        return Icons.hourglass_empty;

    }
  }

  @override
  Widget build(BuildContext context) {
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
        duration: const Duration(milliseconds:180),
        margin: const EdgeInsets.only(bottom:10),
        decoration: BoxDecoration(
          color: hovered
              ? Colors.white.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          child: ExpansionTile(
            leading: Icon(
              getStatusIcon(),
              color: getStatusColor(),
            ),
            title: Row(
              children: [

                Expanded(
                  child: Text(
                    widget.bet.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal:10,
                    vertical:4,
                  ),

                  decoration: BoxDecoration(
                    color: getStatusColor()
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    widget.bet.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize:12,
                    ),
                  ),
                )

              ],
            ),

            subtitle: Row(
              children: [

                Text("${widget.bet.selections.length} eventi"),

                const SizedBox(width:15),

                Text(
                  "Quota ${widget.bet.totalOdd.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
            children:
              widget.bet.selections.map((selection) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal:15,
                    vertical:10,
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Row(
                          children: [

                            Image.network(
                              "${ApiConfig.baseUrl}/uploads/${selection.competitionLogo}",
                              width:30,
                              height:30,
                              errorBuilder: (_,__,___)=> const Icon(Icons.emoji_events),
                            ),

                            const SizedBox(width:8),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "${selection.homeTeam}"
                                    " - "
                                    "${selection.awayTeam}",

                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),


                                  Text(
                                    "Pronostico: "
                                    "${selection.prediction}",
                                  ),

                                  Text(
                                    !selection.settled
                                        ? "Vinto"
                                        : selection.won == true
                                          ? "Vinto"
                                          : "Perso",

                                    style: TextStyle(
                                      fontSize:12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                        !selection.settled
                                            ? Colors.orange
                                            : selection.won == true
                                                ? Colors.green
                                                : Colors.red,
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                      Column(
                        children: [

                          Text(
                            "x${selection.odd}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:16,
                            ),
                          ),

                          Icon(
                            !selection.settled
                                ? Icons.hourglass_empty
                                : selection.won == true
                                    ? Icons.check_circle
                                    : Icons.cancel,
                            color:
                                !selection.settled
                                    ? Colors.orange
                                    : selection.won == true
                                        ? Colors.green
                                        : Colors.red,
                            size:18,
                          ),

                          const SizedBox(height:4),

                          Text(
                            !selection.settled
                                ? "OPEN"
                                : selection.won == true
                                    ? "WON"
                                    : "LOST",
                            style: TextStyle(
                              fontSize:11,
                              fontWeight: FontWeight.bold,
                              color:
                                  !selection.settled
                                      ? Colors.orange
                                      : selection.won == true
                                          ? Colors.green
                                          : Colors.red,
                            ),
                          ),

                        ],
                      )

                    ],
                  ),
                );
              }).toList(),

          ),
        ),
      ),
    );
  }

}