import 'package:flutter/material.dart';

import '/models/bet/bet.dart';
import 'bet_selection_tile.dart';

class BetCard extends StatelessWidget {

  final Bet bet;
  final VoidCallback onRefresh;

  const BetCard({
    super.key,
    required this.bet,
    required this.onRefresh,
  });

  Color statusColor() {
    switch(bet.status) {
      case "WON":
      return Colors.green;

      case "LOST":
      return Colors.red;

      default:
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom:16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[

            Row(
              children:[

                Expanded(
                  child: Text(
                    bet.name,
                    style: const TextStyle(
                      fontSize:18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal:10,
                    vertical:5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bet.status,
                    style: TextStyle(
                      color: statusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize:12,
                    ),
                  ),
                ),

              ],

            ),

            const SizedBox(height:8),

            Text(
              "${bet.selections.length} eventi",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize:13,
              ),
            ),

            const SizedBox(height:16),

            ...bet.selections.map((selection)=>
              BetSelectionTile(selection: selection),),

          ],

        ),
      ),
    );
  }
}