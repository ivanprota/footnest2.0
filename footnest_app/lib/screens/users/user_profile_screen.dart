import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/models/user/user_profile.dart';

import '/services/service_locator.dart';
import '/services/profile_service.dart';

import '/widgets/profile/profile_header.dart';
import '/widgets/profile/profile_stat_card.dart';
import '/widgets/profile/bet_preview_tile.dart';
import '/widgets/profile/prediction_preview_tile.dart';

class UserProfileScreen extends StatefulWidget {

  final int userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  UserProfile? profile;

  bool loading = true;

  List bets = [];
  List predictions = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future loadProfile() async {

    try {

      final service =
          locator<ProfileService>();

      final profileResult =
          await service.getUserProfile(
            widget.userId,
          );

      final betsResult =
          await service.getUserBets(
            widget.userId,
            size: 10,
          );

      final predictionsResult =
          await service.getUserPredictions(
            widget.userId,
            size: 10,
          );

      if (!mounted) return;

      setState(() {
        profile = profileResult;
        bets = betsResult.content;
        predictions = predictionsResult.content;
        loading = false;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Errore nel caricamento del profilo: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profile == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Profilo non disponibile",
          ),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Profilo di ${profile!.username}",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            ProfileHeader(
              profile: profile!,
              onLogout: null,
            ),

            const SizedBox(height: 25),

            Row(
              children: [

                Expanded(
                  child: ProfileStatCard(
                    title: "Schedine",
                    icon: Icons.receipt_long,
                    onTap: () {
                      context.push("/profile/user/${widget.userId}/bets");
                    },
                    items: [

                      ProfileStatItem(
                        label: "Totali",
                        value: profile!.totalBets,
                      ),

                      ProfileStatItem(
                        label: "Vinte",
                        value: profile!.wonBets,
                      ),

                      ProfileStatItem(
                        label: "Perse",
                        value: profile!.lostBets,
                      ),

                      ProfileStatItem(
                        label: "Aperte",
                        value: profile!.openBets,
                      ),

                    ],
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: ProfileStatCard(
                    title: "Pronostici",
                    icon: Icons.tips_and_updates,
                    onTap: () {
                      context.push("/profile/user/${widget.userId}/predictions");
                    },
                    items: [

                      ProfileStatItem(
                        label: "Totali",
                        value: profile!.totalPredictions,
                      ),

                      ProfileStatItem(
                        label: "Vinte",
                        value: profile!.wonPredictions,
                      ),

                      ProfileStatItem(
                        label: "Perse",
                        value: profile!.lostPredictions,
                      ),

                      ProfileStatItem(
                        label: "Aperte",
                        value: profile!.openPredictions,
                      ),

                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 30),

            Text(
              "Ultime schedine",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 10),

            if (bets.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Nessuna schedina presente",
                  ),
                ),
              )
            else
              ...bets.map(
                (bet) => BetPreviewTile(
                  bet: bet,
                  readOnly: true,
                ),
              ),

            const SizedBox(height: 30),

            Text(
              "Ultimi pronostici",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 10),

            if (predictions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Nessun pronostico presente",
                  ),
                ),
              )
            else
              ...predictions.map(
                (prediction) => PredictionPreviewTile(
                  prediction: prediction,
                  readOnly: true,
                  onTap: () {
                    context.push(
                      "/matches/${prediction.matchId}",
                    );
                  },
                ),
              ),

          ],
        ),
      ),
    );
  }
}