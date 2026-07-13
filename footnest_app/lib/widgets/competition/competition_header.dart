import 'package:flutter/material.dart';

import '../../models/competition/competition.dart';

class CompetitionHeader extends StatelessWidget {

  final Competition competition;

  const CompetitionHeader({
    super.key,
    required this.competition,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [

          if (competition.logoPath != null &&
              competition.logoPath!.isNotEmpty)
            Image.network(
              competition.logoPath!,
              height: 100,
            ),

          const SizedBox(height: 16),

          Text(
            competition.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Chip(
            avatar: const Icon(
              Icons.emoji_events_outlined,
              size: 18,
            ),
            label: Text(
              competition.type,
            ),
          ),

        ],
      ),
    );
  }

}