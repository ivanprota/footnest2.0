import 'dart:io';

import '../models/upload/upload_response.dart';
import 'api_client.dart';

class UploadService {

  final ApiClient apiClient;

  UploadService(this.apiClient);

  Future<UploadResponse> uploadTeamLogo(
      File file,
      int competitionSeasonId,
  ) async {

    final response =
        await apiClient.uploadFile(
          '/uploads/team-logo',
          file,
          {
            "competitionSeasonId":
                competitionSeasonId.toString(),
          },
        );

    return UploadResponse.fromJson(response);
  }

}