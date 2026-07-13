import 'package:go_router/go_router.dart';

import '/screens/home/home_screen.dart';
import '/screens/teams/team_details_screen.dart';
import '../screens/competitions/competition_details_screen.dart';
import 'routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,

  routes: [

    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '${AppRoutes.teams}/:id',
      builder: (context, state) {
        final id = int.parse(
          state.pathParameters['id']!,
        );
        return TeamDetailsScreen(
          teamId: id,
        );
      },
    ),

    GoRoute(
      path: '${AppRoutes.competitions}/:id',
      builder: (context, state) {
        final id = int.parse(
          state.pathParameters['id']!,
        );
        return CompetitionDetailsScreen(
          competitionId: id,
        );
      },
    ),

  ],
);