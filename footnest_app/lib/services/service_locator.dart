import 'package:get_it/get_it.dart';

import '/services/api_client.dart';
import '/services/team_service.dart';
import '/services/competition_service.dart';
import '/services/team_details_service.dart';
import '/services/standing_service.dart';
import '/services/competition_season_service.dart';
import '/services/upload_service.dart';
import '/services/football_match_service.dart';


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

}