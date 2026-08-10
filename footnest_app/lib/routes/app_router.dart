import 'package:footnest_app/screens/competitions/competitions_calendar_screen.dart';
import 'package:footnest_app/services/auth_service.dart';
import 'package:footnest_app/services/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '/screens/shell/app_shell.dart';

import '/screens/teams/teams_screen.dart';
import '/screens/teams/team_details_screen.dart';
import '/screens/teams/add_team_screen.dart';
import '/screens/teams/team_statistics_screen.dart';

import '/screens/matches/matches_screen.dart';
import '/screens/matches/match_detail_screen.dart';

import '/screens/competitions/competitions_screen.dart';
import '/screens/competitions/competition_details_screen.dart';

import '/screens/predictions/predictions_screen.dart';

import '/screens/auth/login_screen.dart';
import '/screens/auth/register_screen.dart';

import '/screens/profile/profile_screen.dart';

import '/screens/users/users_screen.dart';
import '/screens/users/user_profile_screen.dart';
import '/screens/users/user_bet_screen.dart';
import '/screens/users/user_prediction_screen.dart';

import 'routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(

  initialLocation: AppRoutes.login,

  redirect: (context, state) async {
    final logged = await locator<AuthService>().isLogged();
    final isLogin = state.matchedLocation == AppRoutes.login;
    final isRegister = state.matchedLocation == AppRoutes.register;

    if (!logged) {
      if (isLogin || isRegister) {
        return null;
      }

      return AppRoutes.login;
    }

    if (logged && (isLogin || isRegister)) {
      return AppRoutes.teams;
    }

    return null;
  },

  routes: [

    // AUTH

    GoRoute(
      path: AppRoutes.login,
      builder: (_,__) => const LoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.register,
      builder: (_,__) => const RegisterScreen(),
    ),


    GoRoute(
      path: '/',
      redirect: (_,__) =>
          AppRoutes.teams,
    ),


    // APP CON SIDEBAR

    StatefulShellRoute.indexedStack(

      builder: (
        context,
        state,
        navigationShell,
      ){

        return AppShell(
          navigationShell: navigationShell,
        );

      },

      branches: [

        // TEAMS
        StatefulShellBranch(
          routes: [

            GoRoute(
              path: AppRoutes.teams,
              builder: (_,__) => const TeamsScreen(),
              routes: [

                GoRoute(
                  path: 'add',
                  builder: (_,__) =>const AddTeamScreen(),
                ),

                GoRoute(
                  path: ':id',
                  builder: (context,state) {
                    return TeamDetailsScreen(
                      teamId: int.parse(
                        state.pathParameters['id']!,
                      ),
                    );
                  },
                  routes: [

                    GoRoute(
                      path: 'statistics',
                      builder: (context, state) {
                        return TeamStatisticsScreen(
                          teamId: int.parse(
                            state.pathParameters['id']!,
                          ),
                        );
                      },
                    ),

                  ]
                ),

              ],
            ),
          ],
        ),

        // MATCHES
        StatefulShellBranch(
          routes: [

            GoRoute(
              path: AppRoutes.matches,
              builder: (_,__) => const MatchesScreen(),
              routes: [

                GoRoute(
                  path: ':id',
                  builder: (context,state) {
                    return MatchDetailScreen(
                      matchId: int.parse(
                        state.pathParameters['id']!,
                      ),
                    );
                  },
                ),

              ],
            ),
          ],
        ),

        // COMPETITIONS
        StatefulShellBranch(
          routes: [

            GoRoute(
              path: AppRoutes.competitions,
              builder: (_,__) => const CompetitionsScreen(),
              routes: [

                GoRoute(
                  path: ':id',
                  builder: (context,state) {
                    return CompetitionDetailsScreen(
                      competitionId: int.parse(
                        state.pathParameters['id']!,
                      ),
                    );
                  },
                  routes: [

                    GoRoute(
                      path: 'calendar',
                      builder: (context, state) {

                        final seasonId = int.parse(
                          state.uri.queryParameters['season']!,
                        );

                        return CompetitionCalendarScreen(
                          competitionSeasonId: seasonId,
                        );
                      },
                    ),

                  ]
                ),

              ],
            ),
          ],
        ),

        // PREDICTIONS
        StatefulShellBranch(
          routes: [

            GoRoute(
              path: AppRoutes.predictions,
              builder: (_,__) => const PredictionsScreen(),
            ),

          ],
        ),

        // -----------------
        // USERS
        // -----------------

        StatefulShellBranch(
          routes: [

            GoRoute(
              path: AppRoutes.users,
              builder: (_,__) => const UsersScreen(),
            ),

          ],
        ),

        // -----------------
        // PROFILE
        // -----------------

        StatefulShellBranch(
          routes: [

            GoRoute(
              path: AppRoutes.profile,
              builder: (_,__) => const ProfileScreen(),
              routes: [

                GoRoute(
                  path: 'user/:id',
                  builder: (context, state) {
                    return UserProfileScreen(userId: int.parse(state.pathParameters['id']!));
                  },
                  routes: [

                    GoRoute(
                      path: 'bets',
                      builder: (context, state) {
                        return UserBetsScreen(
                          userId: int.parse(
                            state.pathParameters['id']!,
                          ),
                        );
                      },
                    ),

                    GoRoute(
                      path: 'predictions',
                      builder: (context, state) {
                        return UserPredictionsScreen(
                          userId: int.parse(
                            state.pathParameters['id']!,
                          ),
                        );
                      },
                    ),

                  ]
                )

              ]
            ),

          ],
        ),

      ],
    ),

  ],

);