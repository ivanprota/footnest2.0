import 'package:flutter/material.dart';

import '/models/bet/bet_selection.dart';
import '/config/api_config.dart';

class BetSelectionTile extends StatelessWidget {

  final BetSelection selection;

  const BetSelectionTile({
    super.key,
    required this.selection,
  });

  String logoUrl(String path) {
    if(path.startsWith("http")) {
      return path;
    }

    return "${ApiConfig.baseUrl}/uploads/$path";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical:10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:Colors.grey.withOpacity(0.15),
          ),
        ),
      ),
      child: Row(
        children:[

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[

                Flexible(
                  child: Text(
                    selection.homeTeam,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),

                const SizedBox(width:8),

                Image.network(
                  logoUrl(selection.homeLogo),
                  width:28,
                  height:28,
                  errorBuilder: (_,__,___)=>
                    const Icon(Icons.shield, size:28),
                ),

              ],

            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10),
            child: Column(
              children:[

                Text(
                  selection.prediction,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  "@${selection.odd}",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize:12,
                  ),
                ),

              ],

            ),
          ),

          Expanded(
            child: Row(
              children:[

                Image.network(
                  logoUrl(selection.awayLogo),
                  width:28,
                  height:28,
                  errorBuilder: (_,__,___)=>
                    const Icon(Icons.shield, size:28),
                ),

                const SizedBox(width:8),

                Flexible(
                  child: Text(
                    selection.awayTeam,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              ],

            ),
          ),

        ],

      ),
    );
  }

}