import 'package:get_it/get_it.dart';

import '/services/api_client.dart';
import '/services/team_service.dart';
import '/services/competition_service.dart';
import '/services/team_details_service.dart';
import '/services/standing_service.dart';
import '/services/competition_season_service.dart';
import '/services/upload_service.dart';
import '/services/football_match_service.dart';
import '/services/auth_service.dart';
import '/services/auth_state_service.dart';
import '/services/prediction_service.dart';
import '/services/bet_service.dart';
import '/services/profile_service.dart';
import '/services/profile_refresh_service.dart';
import '/services/user_service.dart';
import '/services/team_statistics_service.dart';
import '/services/team_refresh_service.dart';

final locator = GetIt.instance;


void setupLocator() {

  locator.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );


  locator.registerLazySingleton<TeamService>(
    () => TeamService(
      locator<ApiClient>(),
    ),
  );


  locator.registerLazySingleton<CompetitionService>(
    () => CompetitionService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton(
      () => TeamDetailsService(
          locator<ApiClient>()
      )
  );

  locator.registerLazySingleton(
    () => StandingService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<CompetitionSeasonService>(
    () => CompetitionSeasonService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<UploadService>(
    () => UploadService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<FootballMatchService>(
    () => FootballMatchService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<AuthService>(
    () => AuthService(
      apiClient: locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<AuthStateService>(
    () => AuthStateService(
      authService: locator<AuthService>(),
    ),
  );

  locator.registerLazySingleton<PredictionService>(
    () => PredictionService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton(
    () => BetService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton(
  () => ProfileService(
        locator()
    ),
  );

  locator.registerLazySingleton<ProfileRefreshService>(
    () => ProfileRefreshService(),
  );

  locator.registerLazySingleton<UserService>(
    () => UserService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<TeamStatisticsService>(
    () => TeamStatisticsService(
      locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<TeamRefreshService>(
    () => TeamRefreshService(),
  );

}