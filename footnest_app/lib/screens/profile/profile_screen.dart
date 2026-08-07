import 'package:flutter/material.dart';
import 'package:footnest_app/services/profile_refresh_service.dart';
import 'package:go_router/go_router.dart';

import '/services/service_locator.dart';
import '/services/profile_service.dart';

import '/models/user/user_profile.dart';
import '/models/bet/bet.dart';
import '/models/prediction/prediction.dart';

import '/widgets/profile/profile_header.dart';
import '/widgets/profile/profile_stat_card.dart';
import '/widgets/profile/bet_preview_tile.dart';
import '/widgets/profile/prediction_preview_tile.dart';

import '/screens/profile/my_bets_screen.dart';
import '/screens/profile/my_predictions_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserProfile? profile;

  List<Bet> bets = [];

  List<Prediction> predictions = [];

  bool loading = true;

  late final ProfileRefreshService refreshService;

  @override
  void initState() {
    super.initState();
    refreshService = locator<ProfileRefreshService>();
    refreshService.addListener(loadData);
    loadData();
  }

  @override
  void dispose() {
    refreshService.removeListener(loadData);
    super.dispose();
  }

  Future<void> loadData() async {
    final service = locator<ProfileService>();
    final profileData = await service.getProfile();
    final betsData =
        await service.getBets(
          size: 10,
        );

    final predictionsData =
        await service.getPredictions(
          size: 10,
        );

    setState(() {
      profile = profileData;
      bets = betsData.content;
      predictions = predictionsData.content;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ProfileHeader(profile: profile!),

            const SizedBox(height:25),

            Row(
              children: [

                Expanded(
                  child: ProfileStatCard(
                    title: "Schedine",
                    icon: Icons.receipt_long,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyBetsScreen(),
                        )
                      );
                    },
                    items: [

                      ProfileStatItem(
                        label:"Totali",
                        value:
                          profile!.totalBets,
                      ),

                      ProfileStatItem(
                        label:"Vinte",
                        value:
                          profile!.wonBets,
                      ),

                      ProfileStatItem(
                        label:"Perse",
                        value:
                          profile!.lostBets,
                      ),

                      ProfileStatItem(
                        label:"Aperte",
                        value:
                          profile!.openBets,
                      ),

                    ],

                  ),
                ),

                const SizedBox(width:20),

                Expanded(
                  child: ProfileStatCard(
                    title:"Pronostici",
                    icon: Icons.tips_and_updates,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyPredictionsScreen()
                        )
                      );
                    },
                    items: [

                      ProfileStatItem(
                        label:"Totali",
                        value:
                          profile!.totalPredictions,
                      ),

                      ProfileStatItem(
                        label:"Vinti",
                        value:
                          profile!.wonPredictions,
                      ),

                      ProfileStatItem(
                        label:"Persi",
                        value:
                          profile!.lostPredictions,
                      ),

                      ProfileStatItem(
                        label:"Aperti",
                        value:
                          profile!.openPredictions,
                      ),

                    ],

                  ),
                )

              ],
            ),

            const SizedBox(height:30),

            Text(
              "Ultime schedine",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height:10),

            ...bets.map(
              (bet)=> BetPreviewTile(bet: bet)
            ),

            const SizedBox(height:30),

            Text(
              "Ultimi pronostici",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height:10),

            ...predictions.map(
              (prediction)=>
                PredictionPreviewTile(
                  prediction: prediction,
                  onTap: () {
                    context.go(
                    "/matches/${prediction.matchId}",
                    );
                  },
                )
            ),
         
          ],
        ),
      ),
    );
  }

}