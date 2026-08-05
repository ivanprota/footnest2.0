import 'package:go_router/go_router.dart';

import '/screens/home/home_screen.dart';
import '/screens/teams/team_details_screen.dart';
import '/screens/teams/add_team_screen.dart';
import '/screens/competitions/competition_details_screen.dart';
import '/screens/matches/match_detail_screen.dart';
import '/screens/auth/login_screen.dart';
import '/screens/auth/register_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/auth/auth_gate.dart';
import 'routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.auth,

  routes: [

    GoRoute(
      path: AppRoutes.auth,
      builder: (context,state) =>
          const AuthGate(),
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: AppRoutes.addTeam,
      builder: (context,state) =>
          const AddTeamScreen(),
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

    GoRoute(
      path: AppRoutes.matchDetails,
      builder: (context, state) {

        final id = int.parse(
          state.pathParameters['id']!,
        );

        return MatchDetailScreen(
          matchId: id,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) =>
          const LoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) =>
          const RegisterScreen(),
    ),

    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) =>
          const ProfileScreen(),
    ),    

  ],
);