import 'package:flutter/material.dart';
import '../../models/user/user_profile.dart';

class ProfileStatsCard extends StatelessWidget {

  final UserProfile profile;

  const ProfileStatsCard({
    super.key,
    required this.profile
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:[

            _stat(
            "Schedine",
            profile.totalBets
            ),

            _stat(
            "Vinte",
            profile.wonBets
            ),

            _stat(
            "Perse",
            profile.lostBets
            ),

            _stat(
            "Aperte",
            profile.openBets
            ),

            _stat(
            "Pronostici",
            profile.totalPredictions
            ),

          ]
        )
      )
    );
  }

  Widget _stat(String title,int value) {
    return Column(
      children:[

        Text(
          value.toString(),
          style: const TextStyle(
            fontSize:22,
            fontWeight:FontWeight.bold
          ),
        ),

        Text(title)

      ]

    );
  }

}